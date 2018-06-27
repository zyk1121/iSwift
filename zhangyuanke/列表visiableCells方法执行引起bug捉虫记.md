## 列表visiableCells方法执行引起bug捉虫记

#### 一、Bugly中的问题描述
[Bugly线上问题1](https://bugly.qq.com/v2/crash-reporting/crashes/900035989/55995?pid=2)

[Bugly线上问题2](https://bugly.qq.com/v2/crash-reporting/crashes/900035989/55974?pid=2)

问题是由于在执行下面那行代码过程中，引起的崩溃：
>
guard var visibleCells = self.tableView?.visibleCells else {return}


#### 二、定位代码问题

从[Bugly线上问题1](https://bugly.qq.com/v2/crash-reporting/crashes/900035989/55995?pid=2)很容易就可以看出，是下图中self.tableView?.visibleCells引起了crash，原因是子线程更新UI。
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/crash/crash_bug.jpg)
但是从bugly上看出，当前代码crash的问题并不都是由于子线程更新UI引起的，而且子线程更新UI也不一定会crash，所以就很好奇，于是尝试复原一下场景，如下。

#### 三、模拟可能的场景
模拟场景测试代码如下：

``` Objective-C 

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; i++) {
        [_datas addObject:@(i)];
    }
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testcell"];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self subThead];
    });
}

- (void)subThead {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self testFunc];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self subThead];
            [self subThead];
            [self subThead];
        });
        
    });
}

- (void)testFunc {
    NSArray *arr = self.tableView.visibleCells;
    NSLog(@"%p",arr);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.datas[indexPath.row]];
    return cell;
}

@end

```
运行后会出现如下的crash，共3种情况，都是iOS中比较经典的crash：

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/crash/crash.jpg)

#### 四、解决办法 
其实解决当前问题的办法‘灰常’简单，相关操作放在主线程即可，毕竟是操作UI嘛！

#### 五、深入思考 
可是为什么visibleCells方法会crash呢，当然是visibleCells方法内部会执行一系列的方法啦，其中有对数组进行操作【增删改】和访问，而且还是在多线程的环境下，肯定会有问题了。相关概念请参考我之前写的wiki：[crash问题追踪1](http://172.16.117.224/ios-team/ios-team/issues/1)、
[crash问题追踪2](http://172.16.117.224/ios-team/ios-team/issues/13)

#### 至于visibleCells方法为什么会那么频繁的操作数组以及内部实现原理，有时间可以再深入调研，不正确的话欢迎指正 - by zyk  
