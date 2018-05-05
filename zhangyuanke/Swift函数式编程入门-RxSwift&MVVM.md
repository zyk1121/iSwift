## Swift函数式编程入门-RxSwift&MVVM
### 一、函数响应式编程&链式编程
我们知道c = a + b，在非函数式编程时期，a和b的值如果发生变化的话，c是不会改变的，那么，函数（响应）式编程呢？

``` Objective-C 
int a = 10;
int b = 20;
int c = a + b;
a = 30;
b = 40;
c = ?
```
网络上流传一个比较经典的用于理解函数响应式编程的图，如下：
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_1.png)
 >
 我们可以理解a是一个信号（信号的概念后续会说明），b也是一个信号，c是a信号和b信号绑定的后的结果；当a信号发生变化，或者b信号发生变化的时候，c信号能够根据其变化而进行联动，可以直接理解为a和b发生变化的时候，由于c绑定了a和b，那么c也能够做出相应的改变（联动响应），这就是响应式的直观理解和概念。
 >
 Excel就是响应式编程的一个例子。单元格可以包含字面值或类似”=B1+C1″的公式，而包含公式的单元格的值会依据其他单元格的值的变化而变化 
 
 那么什么是“链式编程”呢？
 >所谓的链式编程就是可以通过“点”语法，将需要执行的代码块连续的书写下去，使得代码简单易读，书写方便。如A.B.C.D的形式。
 >
我们在学校的时候都学习过面向过程，处理事情以过程为核心，一步一步的实现；面向对象，万物皆对象的思想；而链式编程思想也是一种编程范式，也值得我们去学习和思考。

链式编程的特点以及iOS中如何实现？
 >特点就是代码简单易读，书写方便。
 在之前的Objective-C开发过程中，我们都使用过第三方框架Masonry，它就是基于链式编程思想实现的，而在我们的Swift中，由于已经很好的支持了点语法，所以链式编程变得异常的简单方便。下面演示一下OC中如何实现链式编程（了解内容）。
 
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_2.png)
 
### 二、初见RxSwift
iOS开发中的FRP框架主要有两个最流行和广泛使用：ReactiveCocoa和RxSwift，ReactiveCocoa是OC时期的FRP框架，swift中也有人在用；RxSwift则是利用swift的一些新特性实现的FRP框架，和ReactiveCocoa实现机制不是很一样，但是功能基本上是一致的。
>ReativeCocoa:更适合OC，缺点语法复杂，概念繁多，参考资料少（尤其RAC4），不易理解
RxSwift:对Swift的兼容很好，利用了很多的Swift特性，语法简单，概念清楚

##### 1、对Rx的整体印象
对Rx的整体印象我们可以从如下的示例入手：
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_3.png)
对其进行描述，当搜索框内容发生变化的时候进行网络请求，以及等待一定的时间间隔（2-3s）进行请求，如果想同时实现这两种需求的话：一般要实现一个定时器，在定时器执行到2s的时候，取出当前的内容和上一次的内容进行比较，不一样的话再次进行新的请求，并保留最新请求的参数内容；最后对请求的结果进行处理（正确的结果进行显示等等）。

``` Swift 
 // 当搜索框内容发生变化（2s以上），而且和上一次（请求值）不一样的时候，
        // 对其内容进行搜索请求，返回请求结果的序列值（可观察的序列）
        let observable = searchTextField.rx.text.orEmpty
            .throttle(2, scheduler: MainScheduler.instance)
            .distinctUntilChanged().flatMapLatest {[weak self] (param) -> Observable<String> in
                self?.showLabel1.text = "请求\(param)"
                return (self?.request(param: param))!
            }
        /*
         // throttle是节流的意思，对快速变化的请求内容进行节制
         // MainScheduler.instance在哪个线程执行定时操作
         // distinctUntilChanged 剔除重复值
         // flatMapLatest把网络请求的结果序列取最新的结果进行返回（暂时不用理解）
         */
        // 订阅搜索请求结果序列
        observable.subscribe {[weak self]  (event) in
            // event为订阅的返回结果
            self?.showLabel2.text = event.element
        }.addDisposableTo(disposeBag)
        // 结果放入销毁池中，当当前VC销毁的时候销毁池将释放其内容
```
##### 2、Rx的核心概念
我们知道物理上的信号都是连续的，y=f(t),如下图的右上角的坐标系所示。<br /> 
在之前的ReactiveCocoa中<font face="黑体" color="ff0000">信号</font>的概念贯穿了整个框架，不理解信号也就无法正确使用FRP相关的技术。<br /> 
相似的，Rx中也有类似的概念，称为<font face="黑体" color="ff0000"><u>“序列”</u></font>，它比<font face="黑体" color="ff0000"><u>"信号"</u></font>要更容易理解也更贴切一些。

我们现在可以理解Rx中的<font face="黑体" color="ff0000"><u>“序列”</u></font>是离散的value，毕竟计算机本质上也是离散（非连续）的，Rx中序列都是用<font face="黑体" color="ff0000">“Observable\<Type\>”</font>表示的，也即可观察的序列值，Type可以是Int，String，自定义对象等等。这么说有点抽象，我们还不能体会到序列到底是一个什么东西。

一个简单的栗子就是GPS定位系统(把其想象成为一个可观察的序列，值类型为GPS：Observable\<GPS\>)，当有最新的GPS信号的时候（GPS更新的时候），发出一个值，更新的时间不定，但是数据是离散的序列值。

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_4.png)
>
<font face="黑体" color="ff0000">统一一个叫法：以后说信号也即是序列，序列也即是信号，而且FRP中value都是离散的。</font>

##### 3、订阅者（subscribe）
>
序列（可观察的）是可以被订阅的，订阅者可以有多个。<br /> 
和android中的广播与广播接收者的概念类似（唯一的区别是<font face="黑体" color="008800"><u>冷热信号</u></font>的处理方式不一样，有冷热信号的区分，Android中的广播是热信号的栗子，冷热信号不是特别容易理解，此处可以先暂时有个概念，后续章节再对冷热信号进行详细介绍，我们今天讲的栗子基本上也都是冷的）<br /> 
当有一个订阅者订阅当前的序列的时候，序列中的内容会执行一遍（冷信号），大部分网络请求的情景和此类似。


##### 4、事件（event）
如下图，可观察的序列可以发送3种事件，next（新的元素），error（错误事件），completed（完成事件）给订阅者，订阅者接收事件。<br />
和网络请求的逻辑很像。<br />
同样，订阅者也可以接收3种类型的事件。

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_5.png)

##### 5、订阅者与序列的关系
<img src="http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_6.png" width=256 height=256 />

订阅者可以对可观察的序列进行订阅（可以有多个订阅者），序列通过Event的方式把数据传递给订阅者。

##### 6、序列的常见操作
``` Swift 
//1, empty 是一个空的序列，它只发送 .Completed 消息。
        example("empty") {
            let emptySequence: Observable<Int> = Observable<Int>.empty()
            _ = emptySequence
                .subscribe { event in
                    print(event)
            }
        }
        //2, just 是只包含一个元素的序列，它会先发送 .Next(value) ，然后发送 .Completed
        example("just") {
            let singleElementSequence = Observable<Int>.just(32)
            let subscription = singleElementSequence
                .subscribe { event in
                    print(event)
            }
            subscription.addDisposableTo(disposeBag)
        }
        
        //3, map 就是对每个元素都用函数做一次转换，逐个映射一遍
        example("map") {
            /*
             Transform the items emitted by an Observable by applying a function to each item
             */
            Observable<Int>.of(1, 2, 3)
                .map { "\($0)\($0)" }
                .subscribe{ print($0) }
                .addDisposableTo(disposeBag)
            //输出：11 22 33 字符串
        }
        //4, flatMap：Transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable
        example("flatMap") {
            let sequenceInt = Observable<Int>.of(1, 2)
            let mysequence1 = { (value: Int) -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                        observer.on(.next("\(value)A"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        observer.on(.next("\(value)B"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                        observer.on(.next("\(value)C"))
                    })
                    
                    return Disposables.create()
                })
            }
            let mysequence2 = { (value: Int) -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        observer.on(.next("\(value)A"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                        observer.on(.next("\(value)B"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6, execute: {
                        observer.on(.next("\(value)C"))
                        observer.onCompleted()
                    })
                    
                    return Disposables.create()
                })
            }
            // faltMap
            sequenceInt.flatMap({ (val) -> Observable<String> in
                if val == 1 {
                    return mysequence1(1)
                    // 1A       1B      1C
                } else {
                    return mysequence2(2)
                    //      2A      2B      2C
                }
            }).subscribe({ (event) in
                print(event)
            }).addDisposableTo(disposeBag)
            // 输出：1A 2A 1B 2B 1C 2C
        }
        
        //5, flatMapLatest: Like flatMap, flatMapLatest creates new streams for each source event. Instead of merging all created streams, it "switches" (hence the former name "switch") between them so that when a new stream is created, the earlierly created stream is no longer listened to.
        example("flatMapLatest") {
            let sequenceInt = Observable<Int>.of(1, 2)
            let mysequence1 = { (value: Int) -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        observer.on(.next("\(value)A"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        observer.on(.next("\(value)B"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                        observer.on(.next("\(value)C"))
                    })
                    
                    return Disposables.create()
                })
            }
            let mysequence2 = { (value: Int) -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                        observer.on(.next("\(value)A"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                        observer.on(.next("\(value)B"))
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6, execute: {
                        observer.on(.next("\(value)C"))
                        observer.onCompleted()
                    })
                    
                    return Disposables.create()
                })
            }
            // faltMap
            sequenceInt.flatMapLatest({ (val) -> Observable<String> in
                if val == 1 {
                    return mysequence1(1)
                    // 1A       1B      1C
                } else {
                    return mysequence2(2)
                    //      2A      2B      2C(一旦开始了当前的信号，信号1就停止了监听)
                }
            }).subscribe({ (event) in
                print(event)
            }).addDisposableTo(disposeBag)
            // 输出：2A 2B 2C completed
        }

        //6， filter
        example("filter") {
            let _ = Observable<Int>.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
                .filter {
                    $0 % 2 == 0
                }
                .subscribe {
                    print($0)
            }
            // 输出偶数
        }
        
        //7， distinctUntilChanged 会废弃掉重复的事件(值Value)。
        example("distinctUntilChanged") {
            let _ = Observable<Int>.of(1, 2, 3, 1, 1, 4)
                .distinctUntilChanged()
                .subscribe {
                    print($0)
            }
            // 1 2 3 1 4
        }
        
        //8, take 只获取序列中的前 n 个事件，在满足数量之后会自动 .Completed 。
        example("take") {
            let _ = Observable<Int>.of(1, 2, 3, 4, 5, 6)
                .take(3)
                .subscribe {
                    print($0)
            }
            // 1 2 3 completed
        }
        
        //9， retry 顾名思义，就是在出现异常的时候会再去从头订阅事件序列，妄图通过『从头再来』解决问题；出错的时候重试
        example("retry") {
            var count = 1 // bad practice, only for example purposes
            let funnyLookingSequence: Observable<Int> = Observable.create { observer in
                let error = NSError(domain: "Test", code: 0, userInfo: nil)
                observer.on(.next(0))
                observer.on(.next(1))
                if count < 2 {
                    observer.on(.error(error))
                    count = count + 1
                }
                observer.on(.next(2))
                observer.on(.completed)
                return Disposables.create()
            }
            funnyLookingSequence
                .retry()
                .subscribe {
                    print($0)
            }.addDisposableTo(disposeBag)
            /*
             --- retry example ---
             next(0)
             next(1)
             next(0)
             next(1)
             next(2)
             completed
             */
        }
        
        //10, doOn是在直接onNext处理时候，先执行某个方法，doOnNext( :)方法就是在subscribe(onNext:)前调用，doOnCompleted(:)就是在subscribe(onCompleted:)前面调用的
        example("doOn") {
            let disposeBag = DisposeBag()
            
            Observable.of("1", "2", "3", "4")
                .do(onNext: {
                    print("Intercepted:", $0) }, onError: { print("Intercepted error:", $0) }, onCompleted: { print("Completed")  })
                .subscribe(onNext: {
                    print($0) },onCompleted: { print("结束") })
                .addDisposableTo(disposeBag)
        }
```
##### 7、BindUI
绑定UI是指Rx可以把某一个数据源和某一个UI进行绑定，那么当数据源发生变化的时候，自动对UI进行更新。

```Swift
 var labelData = Variable<String>("abc")
    var swData = Variable<Bool>(false)
    var segData = Variable<Int>(0)
    
    func bindUI()
    {
        // bindto
        _ = labelData.asObservable().bind(to: label.rx.text)
        labelData.value = "hello world"
        
        // sw
        _ = swData.asObservable().bind(to: sw.rx.value)
        
        // segment
        _ = segData.asObservable().bind(to: segment.rx.value)
        
        // 更新数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) { 
            self.labelData.value = "update data"
            self.swData.value = true
            self.segData.value = 2
        }
        
        updateViewConstraints()
    }
```
<center class="half">
    <img src="http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_7.png" width=256 height=512 />
	<img src="http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_8.png" width=256 height=512 />
</center>

##### 8、响应事件的统一（<font face="黑体" color="ff0000">important</font>）
>
我们一直说Rx好，好在哪，我觉得这一部分才是关键，下面我们从下面几个方面来看一下Rx到底有什么优势(贴出代码进行对比):<br />
1，按钮的点击<br />
2，通知 <br />
3，KVO <br />
4，网络请求 <br />
5，定时器

旧的事件操作方式如下(特别的不要忘记移除监听和定时器相关的代码，风格不统一，容易出问题):

``` Swift
   //MARK:-旧的事件操作方式
    func testOldOperation() {
        //1，按钮点击
        btn.addTarget(self, action: #selector(buttonClick(btn:)), for: .touchUpInside)
        //2，通知
        NotificationCenter.default.addObserver(self, selector: #selector(notiResult(noti:)), name: NSNotification.Name.init("testnoti"), object: nil)
        //3, KVO
        testKVO.addObserver(self, forKeyPath: "testStr", options: .new, context: &myContext)
        //4, 网络请求
        // block的形式和Rx很像，如下
        requestOld(param: "test") { (result, error) in
            if error != nil {
                print("request出错")// 出错
            } else {
                if result != nil {
                    print("request成功")//  解析数据
                }}}
        // 还有代理和通知的方式（要在不同的地方写代码）
        //5，定时器,需要销毁invalidate
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    // 按钮点击事件
    func buttonClick(btn:UIButton) {
        print("按钮点击了-old")
    }
    // 通知事件
    func notiResult(noti:Notification) {
        print("接收通知事件-old")
    }
    // KVO
    private var myContext = 0
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeKey.newKey] {
                print("old str changed: \(newValue)")
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    // 定时器
    @objc private func timerFunc()
    {
        print("old timer")
    }
    
```
Rx事件操作方式如下（风格统一，使用方便，问题少，只需注意循环引用相关问题）:

``` Swift
 //MARK:-Rx的统一方式
    func testRxOperation() {
        //1, 按钮点击
        btn.rx.controlEvent(.touchUpInside).subscribe { (event) in
            print("按钮点击了")
        }.addDisposableTo(disposeBag)
        //2，通知
        NotificationCenter.default.rx.notification( NSNotification.Name.init(rawValue: "testnoti")).subscribe { (event) in
            print("接收到通知")
        }.addDisposableTo(disposeBag)
        //3, KVO
        testKVO.rx.observe(String.self, "testStr").subscribe {(event) in
            print("KVO监听")
            print(event)
        }.addDisposableTo(disposeBag)
        //4, 网络请求
        request(param: "rxTest").subscribe(onNext: { (value) in
            print(value)
        }, onError: { (error) in
            print(error)// 出错
        }, onCompleted: { 
            // 完成（成功）的处理
        }) { 
            // 当前订阅者销毁的处理，比如取消了网络请求
        }.addDisposableTo(disposeBag)
        //5，定时器
        Observable<NSInteger>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (sec) in
                print("\(sec) s")
            }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
```

### 三、MVVM架构以及特点
##### 1、MVC的回顾

![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_9.png)

>
如上图，Model持有数据，View显示与用户交互的界面，而view controller调解model和view之间的交互。<br>
MVC：<br>
Model：数据处理逻辑。<br>
View：显示视图逻辑。<br>
Controller：业务逻辑。<br>
上图的解释：视图拥有model和view，model可以通过KVO的方式通知VC层model的变化，由VC控制view的展示；而用户与view的交互则直接通过VC来改变model的内容。
<br>
MVC模式下VC层包含了大量的逻辑处理，比较臃肿，MVVM模式的出现，正式为了减轻VC的负重，使得设计更加的低耦合，可重用以及可测试。

##### 2、MVVM架构
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_10.png)

>
Model负责数据逻辑；<br>
ViewModel：负责业务逻辑以及为view提供数据源；<br>
View：负责视图逻辑<br>
视图逻辑实现、动画、页面跳转、弹框、提示等操作可以放到ViewController处理

##### 3、MVVM架构的特点
>
MVVM模式和MVC模式一样，主要目的是分离视图（View）和模型（Model），有几大优点
1. 低耦合。视图（View）可以独立于Model变化和修改，一个ViewModel可以绑定到不同的"View"上，当View变化的时候Model可以不变，当Model变化的时候View也可以不变。<br>
2. 可重用性。你可以把一些视图逻辑放在一个ViewModel里面，让很多view重用这段视图逻辑。<br>
3. 独立开发。开发人员可以专注于业务逻辑和数据的开发（ViewModel），设计人员可以专注于页面设计，使用Expression Blend可以很容易设计界面并生成xaml代码。<br>
4. 可测试。界面素来是比较难于测试的，而现在测试可以针对ViewModel来写。


### 四、MVVM实战
我们要实现如下的一个界面和逻辑：当用户输入用户名和密码的时候进行判断，当用户输入的用户名和密码长度都大于6时按钮可点击，点击登录按钮进行网络请求，验证当前数据是否正确，正确的话下方显示登录成功+用户名。
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_11.png)

我们的MVVM架构方式代码结构如下：

<img src="http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx/rx_12.png" width=256 height= />

下面给出Controller中的代码和ViewModel中的代码：

``` Swift
class RxMVVMViewController: UIViewController {

    // rx释放池
    let disposeBag = DisposeBag()
    // MainView
    let mainView = RXMVVMMainView()
    // ViewModel
    let mainViewModel = RXMVVMViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "MVVM"
        setupUI()
        bindUI()
        view.setNeedsUpdateConstraints()
    }
    
    func setupUI() {
        view.addSubview(mainView)
    }
    
    func bindUI() {
        // 登录按钮点击
        mainView.longinButton.rx.controlEvent(UIControlEvents.touchUpInside).asObservable().subscribe {[weak self] (event) in
            self?.loginButtonClicked()
            }.addDisposableTo(disposeBag)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        mainView.snp.remakeConstraints { (make) in
            make.top.equalTo(view).offset(64)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    private func loginButtonClicked()
    {
        guard let userName = mainView.username.text,
            let password = mainView.password.text else {
                return
        }
        print("-----开始登录请求，加载中....")
        SVProgressHUD.show(withStatus: "加载中...")
        mainViewModel.userLogin(name: userName, password: password).subscribe(onNext: {[weak self] (usermodel) in
            print("请求成功")
            let strongSelf = self!
            if usermodel.isLogin {
                DispatchQueue.main.async {
                    Observable<String>.just("登录成功：\(usermodel.userName)").asDriver(onErrorJustReturn: "登录失败").asObservable().bind(to:strongSelf.mainView.showResult.rx.text).addDisposableTo(strongSelf.disposeBag)
                }
            }
            
            }, onError: { (error) in
                print("请求失败")
                print("----加载loading完成")
                SVProgressHUD.dismiss()
        }, onCompleted: {
            SVProgressHUD.dismiss()
            print("完成onCompleted")
            print("----加载loading完成")
        }) {
            SVProgressHUD.dismiss()
            print("取消订阅")// 需要的时候特殊处理
            }.addDisposableTo(disposeBag)
    }
    
    deinit {
        print(self)
    }
}
``` 


``` Swift
class RXMVVMViewModel: NSObject {
    let request:RXMVVMRequest = RXMVVMRequest()
    func userLogin(name:String,password:String) -> Observable<UserModel> {
        return Observable.create({ (observer) -> Disposable in
            var dic = [String:String]()
            dic["username"] = name
            dic["password"] = password
            // 注意循环引用，block一旦释放，循环引用自动解除
            self.request.fetchDataWith(param: dic) {[weak self] (result, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    let um = self?.convertToModel(param: result as? [String:String])
                    if um != nil {
                        observer.onNext(um!)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "dddd", code: -1, userInfo: nil))
                    }
                }
            }
            // 不需要处理dispose信息时的返回值Disposables.create()，当需要中断网络请求时可以在此处处理
            return Disposables.create()
        })
    }
    
    // 将字典转换成模型
    func convertToModel(param:[String:String]?) -> UserModel {
        if param == nil {
            return UserModel()
        }
        let um = UserModel()
        um.isLogin = true
        um.userName = param?["username"] ?? ""
        um.password = param?["password"] ?? ""
        um.age = 20
        return um
    }
    
    deinit {
        print(self)
    }
}
```

### 五、总结以及展望

>
>本章节仅仅是对Rx进行一个入门的介绍，后续还会（有时间的话）为大家带来更多关于冷信号、热信号、Schedulers、Rx内存管理等相关知识的理解和分享。
>
>鉴于本人Swift学习还不是很久，Rx也只是初学，本文也仅仅是一个入门的教程，整理的过程中难免出现理解有误的地方，欢迎随时指出和交流~
>
>期待与组内同学一起成长和进步~
