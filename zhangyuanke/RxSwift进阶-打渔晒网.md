## RxSwift进阶—打渔晒网
&emsp;&emsp;上次关于Rx的分享主要是函数式编程FRP和Rx信号的基本概念，以及Rx常用的方法和MVVM的应用，并没有对Rx更深一层的冷热信号以及内存管理和多线程进行介绍，考虑到近期有些空闲时间，就对相关内容进行了梳理，分享给大家，方便大家在应用Rx的时候能知道怎么用，以及知道为什么这么用。
### 一、冷热信号
下面先看一个小故事：
>
   &emsp;&emsp;改革开放初期，有两个小镇：冰冷镇和热情镇，都有着原始的捕鱼方式-网鱼，分别有两个家族Cold和Hot，都想开个渔场，为那些不愿自己捕鱼的人提供服务，但是由于两个镇的情况不同，所以他们采用了不同的经营模式，而共通点是人们都采用预定的方式购鱼。<br />
	&emsp;&emsp;冰冷镇由于人员流动比较大，订鱼的人员以及时间都不定，但是Cold家族庞大，只要有人预定，他就可以命人去打渔，所以Cold采用了懒散的管理方式，没有人订鱼的时候大家各干各的事情，有人预定的时候，就命人去打渔，之后把自家的渔网清理清理，进行晾晒。<br />
	&emsp;&emsp;而热情镇则不同，每年都是那么些固定的人员订鱼，只是时间可能不统一，而且Hot家族就一张大渔网，所以，每次他们都是捕很多鱼回来，看哪些人订了，就给他们送去，每天只是打渔一次，就把网给晒了。<br />
	&emsp;&emsp;当然了，各有各的好处和弊端，Cold采用的模式的好处是随时可以预定，并给人送货，Hot的模式就不行，而Cold会浪费很多人力和物力。<br />
	&emsp;&emsp;当然，网用完了是要晒的，如果不晒，下次就不能用了。
<div align = right>——打渔晒网</div>

下面先看一下冰冷镇最初采取的管理模式，如下：
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/1.jpg)
模式采用预定者向预定中心进行发起订阅的方式，每一次预定，冰冷镇的预定中心都会派一个打渔者专门去打渔，打到鱼后直接把鱼发送给预定的人，之后对渔网进行处理，以便下一次打渔用。<br />
而热情镇由于人员以及工具的因素，不能像冰冷镇那样，每天只能出去打渔一次，所以他们会事先收集一下有哪些人需要预定，等打渔的人回来后统一进行处理，给当前订单中存在的人发货。而且，如果中间有人想取消，直接告诉预定中心就好了，预定中心会和处理中心进行信息的同步，不会给已经取消的用户发货。
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/2.jpg)
看到热情镇的管理模式后，冰冷镇想到了自己的不足，不能给已经取消的用户也发货啊！特别是已经有部分人利用了这个漏洞，每天订完了后在合适的时机取消，每天还是能收到很美味的鱼，天天偷着乐！可冰冷镇的管理者也不是吃素的，很快就效仿热情镇的模式进行了调整（里面的内容不说大家也能明白了）：
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/3.jpg)
>
冰冷镇的大致预定流程是：有预定的人subscribe了一条鱼，那么预定中心就会创建一个Observable<鱼>的一个可观察的序列（也就是说派一个人去捕鱼，捕到鱼后送处理中心处理即可），同时返回给预定者一个特殊的标记disposer，如果预定者想退订也可以，直接调用disposer的dispose方法即可退订。当捕鱼员捕到鱼后送处理中心，处理中心检查一下预定者是否取消了订阅（因为在捕鱼的过程中不知道预定者是否取消了，那时候，没有手机不方便，只有捕鱼回来后才知道具体信息），如果未取消，处理中心会把鱼寄出去，否则，把鱼放生或者自己吃掉也ok。之后当然要晒鱼网啦，吃饭的家伙要好好爱惜嘛！

 下面是一段冷信号相关的代码：

``` Swift 
let subscribeCenter = { (count:Int) -> Observable<String> in
    return Observable.create({ (observer) -> Disposable in
        print("有人订了\(count)条鱼，开始捕鱼...")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(count), execute: {
            observer.on(.next("\(count)条" + "鱼"))
            observer.on(.completed)
        })
        return Disposables.create()
    })
}
let obser:Observable<String> = subscribeCenter(1)
obser.subscribe { (event) in
    print(event)
}.addDisposableTo(disposeBag)
```
热信号相关的代码（注释已经进行了解释）：

``` Swift  
 // PublishSubject会发送订阅者从订阅之后的事件序列。
example("PublishSubject") {
    let subject = PublishSubject<String>()
    writeSequenceToConsole("1", sequence: subject)
    subject.on(.next("a"))
    subject.on(.next("b"))
    writeSequenceToConsole("2", sequence: subject)
    subject.on(.next("c"))
    subject.on(.next("d"))
}
//ReplaySubject 在新的订阅对象订阅的时候会补发所有已经发送过的数据队列， bufferSize 是缓冲区的大小，决定了补发队列的最大值。如果 bufferSize 是1，那么新的订阅者出现的时候就会补发上一个事件，如果是2，则补两个，以此类推。
example("ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    writeSequenceToConsole("1", sequence: subject)
    subject.on(.next("a"))
    subject.on(.next("b"))
    writeSequenceToConsole("2", sequence: subject)
    subject.on(.next("c"))
    subject.on(.next("d"))
}
// BehaviorSubject 在新的订阅对象订阅的时候会发送最近发送的事件，如果没有则发送一个默认值。
example("BehaviorSubject") {
    let subject = BehaviorSubject(value: "z")
    writeSequenceToConsole("1", sequence: subject)
    subject.on(.next("a"))
    subject.on(.next("b"))
    writeSequenceToConsole("2", sequence: subject)
    subject.on(.next("c"))
    subject.on(.completed)
}
    
/*
 Variable 是基于 BehaviorSubject的一层封装，它的优势是：不会被显式终结。即：不会收到 .Completed 和 .Error 这类的终结事件，它会主动在析构的时候发送 .Complete 。
 */
example("Variable") {
    let variable = Variable<String>("z")
    writeSequenceToConsole("1", sequence: variable.asObservable())
    variable.value = "a"
    variable.value = "b"
    writeSequenceToConsole("2", sequence: variable.asObservable())
    variable.value = "c"
}
```
>
关于冷热 Observable 的异同，简而言之，Cold Observable（以下简称CO）只有在被订阅的时候才会发射事件，每次有新的订阅者都会把之前所有的事件都重新发射一遍； Hot Observable（以下简称HO）则是实时的，一旦有新的事件它就发射，不管有没有被订阅，而新的订阅者并不会接收到订阅前已经发射过的事件（实在想接收之前的也不是不可以，但是序列不会重新发送，只是发送之前已经发送过的值）。<br />
HO 有点“推模型”的意思，它会 push 新的事件过来，一些实时性要求较高的场景（最形象的是：定位和各种通知）。
  而CO 则有点“拉模型”的意思，只在需要的时候去 pull（subscribe），所以在封装网络请求和一些异步操作的时候，可以使用CO。
 
### 二、Rx线程管理
RxSwift内置的Scheduler
>
CurrentThreadScheduler(串行) 当前线程Scheduler，默认使用的线程<br />
MainScheduler(串行) 主线程<br />
SerialDispatchQueueScheduler 封装了GCD的串行队列<br />
ConcurrentDispatchQueueScheduler 封装了GCD的并行队列，这个在有任务要在后台执行的时候很有用<br />
OperationQueueScheduler 封装了NSOperationQueue<br />

```swift
// 当前线程
let _ = Observable.just(10).observeOn(CurrentThreadScheduler.instance)
    .subscribe { event in
        print(Thread.current,event)
}
// 主线程
let _ = Observable.just(10).observeOn(MainScheduler.instance)
    .subscribe { event in
        print(Thread.current,event)
}
// 子线程
let queue1 = ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background)
let _ = Observable.just(10).observeOn(queue1)
    .subscribe { event in
        print(Thread.current,event)
}
// 子线程
let queue2 = ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.default)
let _ = Observable.just(10).observeOn(queue2)
    .subscribe { event in
        print(Thread.current,event)
}
// 主线程
let queue3 = OperationQueueScheduler.init(operationQueue: OperationQueue.main)
let _ = Observable.just(10).observeOn(queue3)
    .subscribe { event in
        print(Thread.current,event)
}
// 子线程
let queue4 = OperationQueueScheduler.init(operationQueue: OperationQueue())
let _ = Observable.just(10).observeOn(queue4)
    .subscribe { event in
        print(Thread.current,event)
}
// 子线程
let queue5 = SerialDispatchQueueScheduler.init(internalSerialQueueName: "serial")
let _ = Observable.just(10).observeOn(queue5)
    .subscribe { event in
        print(Thread.current,event)
}
```
需要注意的是当同时设置了subscribeOn和observeOn的任务队列后，只有observeOn起作用，所以用的时候可以优先考虑observeOn的方法即可。

```swift
// 子线程
let queue = ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background)
let _ = Observable.just(10).subscribeOn(queue)
    .subscribe { event in
        print(Thread.current,event)
}
// 子线程
let _ = Observable.just(10).observeOn(queue).subscribeOn(MainScheduler.instance)
    .subscribe { event in
        print(Thread.current,event)
}
// 主线程
let _ = Observable.just(10).observeOn(MainScheduler.instance).subscribeOn(queue)
    .subscribe { event in
        print(Thread.current,event)
}
// 主线程
let _ = Observable.just(10).subscribeOn(queue).observeOn(MainScheduler.instance)
    .subscribe { event in
        print(Thread.current,event)
}
```

### 三、Rx内存管理
（重点）主要是下面的内容，但是需要具体详细讲解，此处略。。。
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/4.jpg)
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/5.jpg)
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/6.jpg)
![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx2/7.jpg)

### 四、实战
下面实现一个计数器（自己理解一下就OK了）：<br />
第一次尝试：失败~

``` Swift
  func counter1(num:Int) {
        let counter:Observable<Int> = Observable.create({ (observer) -> Disposable in
            var n:Int = 1
            while true {
                observer.on(.next(n))
                n += 1
            }
            return Disposables.create()
        })
        // ----------------
        var dispose:Disposable?
        dispose = counter.subscribe({ (event) in
            if event.element! >= num {
                dispose?.dispose()
            }
            print("计数：\(event.element!)")
        })
        dispose?.addDisposableTo(disposeBag)
    }
```
第二次尝试：失败~

``` Swift
    func counter2(num:Int) {
        let counter:Observable<Int> = Observable.create({ (observer) -> Disposable in
            var n:Int = 1
            var continueFlag:Bool = true
            let dispose = Disposables.create {
                continueFlag = false
            }
            while continueFlag {
                observer.on(.next(n))
                n += 1
            }
            return dispose
        })
        // ----------------
        var dispose:Disposable?
        dispose = counter.subscribe({ (event) in
            if event.element! >= num {
                dispose?.dispose()
            }
            print("计数：\(event.element!)")
        })
        dispose?.addDisposableTo(disposeBag)
    }
```
第三次尝试：成功~

``` Swift
   func counter3(num:Int) {
        let counter:Observable<Int> = Observable.create({ (observer) -> Disposable in
            var n:Int = 1
            var continueFlag:Bool = true
            let dispose = Disposables.create {
                continueFlag = false
            }
            DispatchQueue.main.async {
                while continueFlag {
                    observer.on(.next(n))
                    n += 1
                }
            }
            return dispose
        })
        // ----------------
        var dispose:Disposable?
        dispose = counter.subscribe({ (event) in
            if event.element! >= num {
                dispose?.dispose()
            }
            print("计数：\(event.element!)")
        })
        dispose?.addDisposableTo(disposeBag)
    }
```

### 五、总结以及展望
>
>本章节仅仅是对Rx关于冷信号、热信号、Schedulers、Rx内存管理等相关知识的理解和分享。整理的过程中难免出现理解有误的地方，欢迎随时指出和交流~
>
>期待与组内同学一起成长和进步~
