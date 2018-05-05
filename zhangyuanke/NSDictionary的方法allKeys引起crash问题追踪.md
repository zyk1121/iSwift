## NSDictionary的方法allKeys引起crash问题追踪

#### 一、Bugly中的问题描述
[#47248 SIGSEGV](https://bugly.qq.com/v2/crash-reporting/crashes/900035989/47248?pid=2)

错误堆栈如下图所示，crash的原因大致就是在执行NSDictionary的allKeys方法的过程中，创建了一个数组，而创建数组的过程中崩溃。

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/allkeys/1.jpeg)

#### 二、定位代码问题
``` Objective-C 
- (void)registerTimeoutApi:(id<DDAPIScheduleProtocol>)api
{
    double delayInSeconds = [api requestTimeOutTimeInterval];
    if (delayInSeconds == 0)
    {
        return;
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[_apiRequestMap allKeys] containsObject:MAP_REQUEST_KEY(api)])
        {
            [[MTTSundriesCenter instance] pushTaskToSerialQueue:^{
                RequestCompletion completion = [(DDSuperAPI*)api completion];
                NSError* error = [NSError errorWithDomain:@"请求超时" code:Timeout userInfo:nil];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,error);
                    }
                });
                [self p_requestCompletion:api];
            }];
        }
    });
}
```
从bugly上看出现问题的代码是下面这行的[_apiRequestMap allKeys]方法。
>
 if ([[_apiRequestMap allKeys] containsObject:MAP_REQUEST_KEY(api)])
 
经过分析发现，可能引起crash的原因是多线程同时操作了字典的移除以及访问allKeys方法，p_requestCompletion方法可能会在子线程执行。

``` Objective-C 
- (void)p_requestCompletion:(id<DDAPIScheduleProtocol>)api
{    
    [_apiRequestMap removeObjectForKey:MAP_REQUEST_KEY(api)];
    
    [_apiResponseMap removeObjectForKey:MAP_RESPONSE_KEY(api)];
}
```
#### 三、模拟可能的场景
由于线上发生当前问题的场景及次数不多，所以基本无法直接复现，故分析代码后模拟可能出现的场景写了如如下测试代码：


``` Objective-C 
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5"];
    for (int i = 0; i < 1000; i++) {
        [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[DDAPISchedule instance] registerApi:obj];
            });
        }];
        [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [[DDAPISchedule instance] registerTimeoutApi:obj];
            });
        }];
    }
}
@end

@interface DDAPISchedule()
@end

@implementation DDAPISchedule
{
    NSMutableDictionary* _apiRequestMap;
    NSMutableDictionary* _apiResponseMap;
}

+ (instancetype)instance
{
    static DDAPISchedule* g_apiSchedule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_apiSchedule = [[DDAPISchedule alloc] init];
    });
    return g_apiSchedule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _apiRequestMap = [[NSMutableDictionary alloc] init];
    
        _apiScheduleQueue = dispatch_queue_create("com.sunlands.im.apiSchedule", DISPATCH_QUEUE_SERIAL);
        _serialQueue = dispatch_queue_create("com.sunlands.SundriesSerial", NULL);
    }
    return self;
}

- (BOOL)registerApi:(NSString *)api {
    __block BOOL registSuccess = NO;
    dispatch_sync(self.apiScheduleQueue, ^{
        [_apiRequestMap setObject:@1 forKey:api];
        registSuccess = YES;
    });
    return registSuccess;
}

- (void)registerTimeoutApi:(NSString *)api
{
    if ([[_apiRequestMap allKeys] containsObject:api])
    { 
          [self p_requestCompletion:api];
    }
}
- (void)p_requestCompletion:(NSString *)api
{
    [_apiRequestMap removeObjectForKey:api];
}

@end
```
运行后会出现如下的crash：

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/allkeys/2.jpeg)

#### 四、直接原因及解决办法 
导致当前crash的直接原因是：_apiRequestMap在执行allKeys方法的过程中_apiRequestMap内容发生了变化，比如removeObjectForKey执行了，导致初始化数组的时候获取到了空nil的数据引起，根本原因还是多线程同时操作数据源导致。

解决办法：
>
1、相关操作放在同一个线程，比如主线程。<br>
2、相关操作加锁处理，比如下面的代码。

``` Objective-C 
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5"];
    for (int i = 0; i < 1000; i++) {
        [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[DDAPISchedule instance] registerApi:obj];
            });
        }];
        [arr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [[DDAPISchedule instance] registerTimeoutApi:obj];
            });
        }];
    }
}
@end

@interface DDAPISchedule()
@end

@implementation DDAPISchedule
{
    NSMutableDictionary* _apiRequestMap;
    NSMutableDictionary* _apiResponseMap;
    NSLock *_lock;
}

+ (instancetype)instance
{
    static DDAPISchedule* g_apiSchedule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_apiSchedule = [[DDAPISchedule alloc] init];
    });
    return g_apiSchedule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _apiRequestMap = [[NSMutableDictionary alloc] init];
    
        _apiScheduleQueue = dispatch_queue_create("com.sunlands.im.apiSchedule", DISPATCH_QUEUE_SERIAL);
        _serialQueue = dispatch_queue_create("com.sunlands.SundriesSerial", NULL);
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)registerApi:(NSString *)api {
    __block BOOL registSuccess = NO;
    dispatch_sync(self.apiScheduleQueue, ^{
        [_lock lock];
        [_apiRequestMap setObject:@1 forKey:api];
        [_lock unlock];
        registSuccess = YES;
    });
    return registSuccess;
}

- (void)registerTimeoutApi:(NSString *)api
{
    [_lock lock];
    if ([[_apiRequestMap allKeys] containsObject:api])
    {   [_lock unlock];
          [self p_requestCompletion:api];
    } else {
        [_lock unlock];
    }
}
- (void)p_requestCompletion:(NSString *)api
{
    [_lock lock];
    [_apiRequestMap removeObjectForKey:api];
    [_lock unlock];
}

@end
```

#### 五、为什么会crash在字典的allKeys方法
其实我们看到的方法比如allKeys在多线程环境中并不是简单的一条指令，而是会转换为更为底层的C或C++代码，甚至是汇编指令，而多线程在执行指令的过程中，在其时间片执行完的时刻停留在哪条指令是不确定的。知道了这个概念之后，后面的内容就好理解了。

[NSDictionary实现原理](https://blog.csdn.net/shihuboke/article/details/78454401)

[CFDictionary源码](https://opensource.apple.com/source/CF/CF-855.14/CFDictionary.c.auto.html)

参考上面两个链接，猜测allKeys方法的内部实现应该是下面这样子的[伪代码]：

``` Objective-C 
- (NSArray<NSString *> *)allKeys {
    NSUInteger count = CFDictionaryGetCount(dict);
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
    char *keys[count];
    id *values[count];
    CFDictionaryGetKeysAndValues(dict,&keys,&values);
    for (int i = 0; i < count; i++) {
        [tempArray insertObject:keys[i] atIndex:i];
    }
    return [tempArray copy];
}
```
可能的原因是在insertObject之前取出的count和真正insertObject插入数据时候的keys[i]不一致。
>
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[3]'


#### 这个问题我这边跟了一段时间，尽管没有找到相关源码，但感觉原理应当如此，还是把相关想法记录到此，后续如果有新的理解或认识会再修正，不正确的话欢迎指正 - by zyk  
