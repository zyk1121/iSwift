//
//  RxSchedulersViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/11/27.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSchedulersViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        test()
//        create()
//        gcdTest()
//        testFanxing(str: "134")
//        testMap()
//        hotSignal()
        
        create()
    }
    
    /*参考一开始的Hot Observables的论述和两段小程序的输出结果，我们可以确定冷热信号的如下特点：
     
     热信号是主动的，即使你没有订阅事件，它仍然会时刻推送。如第二个例子，信号在50秒被创建，51秒的时候1这个值就推送出来了，但是当时还没有订阅者。而冷信号是被动的，只有当你订阅的时候，它才会发送消息。如第一个例子。
     热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息。如第二个例子，订阅者1和订阅者2是共享的，他们都能在同一时间接收到3这个值。而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送。如第一个例子，我们可以观察到两个订阅者没有联系，都是基于各自的订阅时间开始接收消息的。
     好的，至此我们知道了什么是冷信号与热信号，了解了它们的特点。下一篇文章我们来看看为什么要区分冷信号与热信号。
     
     */
    
    func testMap()
    {
        let myJust = { (singleElement: Int) -> Observable<Int> in
            return Observable.create({ (observer) -> Disposable in
                
                
                print("发送网络请求")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    observer.on(.next(1))
                    //                    observer.on(.completed)
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    observer.on(.next(2))
                    //                    observer.on(.completed)
                })
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
                    observer.on(.next(3))
                    observer.on(.completed)
                })
                
               
                // 不需要处理dispose信息时的返回值
                return Disposables.create()
            })
        }
        
//        let dispose = myJust(22).subscribe(TestObserver())
//        
//        let dis = myJust(23).subscribe { (event) in
//            print("")
//        }
        
//        dispose.dispose()
        
        let jus = myJust(5).map { (value) -> Int in
            return value * 10
        }
        
        
        let flatMap = Observable.just(1).flatMap { (val) -> Observable<Int> in
            return myJust(30)
        }
        
        let fff = flatMap.map { (val) -> Int in
            val * 100
        }.map { (val) -> Int in
            val * 2
        }.map { (val) -> Int in
            val * 3
        }.shareReplay(2).asObservable()
        
       
        
//        flatMap.subscribe { (event) in
//            print(event)
//        }
        
   
        
        // 订阅之后热信号才work，否则还是冷信号
//        fff.subscribe { (event) in
//            print(event)
//        }
//        
//        fff.subscribe { (event) in
//            print(event)
//        }
//        
//        fff.subscribe { (event) in
//            print(event)
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
//            print("----dddddddddddd")
//            
//            fff.subscribe { (event) in
//                print(event)
//            }
//        }
        
        
//       Observable.just(10).subscribe { (event) in
//        print(event)
//        }
        
        myJust(11).subscribe { (event) in
            print(event)
        }
        
//         let dispose = Observable.just(10).subscribe(TestObserver())
    }
    
    
    func testFanxing<TT>(str:TT)
    {
        print(str)
    }
    
    func gcdTest()
    {
        
        
//        print("1")
//        // 异步在主线程执行
//        DispatchQueue.main.async {
//            print(Thread.current)
//            print("2")
//        }
//        print("3")
//        // 1 3 2
        
        
        
//        print("1")
//        // 同步在主线程执行（死锁）
//        DispatchQueue.main.sync {
//            print(Thread.current)
//            print("2")
//        }
//        print("3")
        
        
        // 总之, 需要记住的就是, 同步执行并没有开启子线程的能力, 所有的操作, 都是在当前线程执行.
        // 同步执行没有开启新线程的能力, 所有的任务都只能在当前线程执行
//        异步执行有开启新线程的能力, 但是, 有开启新线程的能力, 也不一定会利用这种能力, 也就是说, 异步执行是否开启新线程, 需要具体问题具体分析
        print("1")
        // 同步在并发队列执行
        DispatchQueue.global().sync {
            print(Thread.current)
            print("2-1")
        }
        DispatchQueue.global().sync {
            print(Thread.current)
            print("2-2")
        }
        DispatchQueue.global().sync {
            print(Thread.current)
            print("2-3")
        }
        print("3")
        
        
//        print("1")
//        // 异步在并发队列执行
//        DispatchQueue.global().async {
//            print(Thread.current)
//            print("2-1")
//        }
//        DispatchQueue.global().async {
//            print(Thread.current)
//            print("2-2")
//        }
//        DispatchQueue.global().async {
//            print(Thread.current)
//            print("2-3")
//        }
//        print("3")
        
        
//        let group = DispatchGroup()
//        DispatchQueue.main.async(group: group, execute: DispatchWorkItem.init(block: { 
//            print("1")
//        }))
//        DispatchQueue.main.async(group: group, execute: DispatchWorkItem.init(block: {
//            print("2")
//        }))
//        DispatchQueue.main.async(group: group, execute: DispatchWorkItem.init(block: {
//            print("3")
//        }))
////        group.enter()
////        group.leave()
//        group.notify(queue: DispatchQueue.main) {
//            print("end")
//        }
        
        
        
    }

    func test()
    {
        example("just") {
            let singleElementSequence = Observable<Int>.just(100)
            let subscription = singleElementSequence
                .observeOn(CurrentThreadScheduler.instance).subscribe { event in
                    print(Thread.current)
                    print(event)
            }
            subscription.addDisposableTo(disposeBag)
        }
    }

    
    func create() {
        example("create") {
//            Observable.just(10)
            // 不需要处理dispose信息时的返回值
            let myJust = { (singleElement: Int) -> Observable<Int> in
                return Observable.create({ (observer) -> Disposable in
                    
                    DispatchQueue.global().async {
                        print(Thread.current)
                        print("-----")
                        observer.on(.next(singleElement))
                        observer.on(.completed)
                    }
                    
                    
                    
                    // 不需要处理dispose信息时的返回值
                    return Disposables.create()
                })
            }
            
//            let subscription = myJust(5)
//                .subscribe { event in
//                    
//                    print(Thread.current)
//                    print(event)
//            }
            
            // 当前线程(那个线程发送，在哪个线程执行，默认线程)
//            let subscription = myJust(5).observeOn(CurrentThreadScheduler.instance)
//                .subscribe { event in
//                    
//                    print(Thread.current)
//                    print(event)
//            }
            
            // 主线程，执行
//            let subscription = myJust(5).observeOn(MainScheduler.instance)
//                .subscribe { event in
//                    
//                    print(Thread.current)
//                    print(event)
//            }
            
            // 串行队列，不会开启新的线程，同步执行
//            let serialQueue = SerialDispatchQueueScheduler.init(internalSerialQueueName: "heagieghie")
//            let subscription = myJust(5).observeOn(serialQueue)
//                .subscribe { event in
//                    
//                    print(Thread.current)
//                    print(event)
//            }

            /*
             RxSwift内置的Scheduler
             通常，使用内置的Scheduler足矣。
             CurrentThreadScheduler(串行) 当前线程Scheduler，默认使用的
             MainScheduler(串行) 主线程
             SerialDispatchQueueScheduler 封装了GCD的串行队列
             ConcurrentDispatchQueueScheduler 封装了GCD的并行队列，这个在有任务要在后台执行的时候很有用
             OperationQueueScheduler 封装了NSOperationQueue
             */
            // 并发队列
            
            // 子线程
//            let queue3 = SerialDispatchQueueScheduler.init(internalSerialQueueName: "serial")
//            let _ = Observable.just(10).observeOn(queue3)
//                .subscribe { event in
//                    print(Thread.current,event)
//            }
            
//            let queue3 = SerialDispatchQueueScheduler.init(qos: DispatchQoS.default)
//            let _ = Observable.just(10).observeOn(queue3)
//                .subscribe { event in
//                    print(Thread.current,event)
//            }
            
//            let queue3 = SerialDispatchQueueScheduler.init(qos: DispatchQoS.background)
//            let _ = Observable.just(10).observeOn(queue3)
//                .subscribe { event in
//                    print(Thread.current,event)
//            }
            
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
            
            /*
            
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
 
 */
            
//            subscription.addDisposableTo(disposeBag)
        }
    }
    
    deinit {
        print(self)
    }
}


class TestObserver: ObserverType {
    typealias E = Int
    func on(_ event: Event<Int>) {
        print(event)
    }
    
    func onNext(_ element: Int) {
        print("next")
    }
    func onCompleted() {
        print("completed")
    }
}

struct Model {
    let age:Int
}

protocol TableViewCell {
    associatedtype T
    func upda(_ data:T)
}


//遵守TableViewCell
class MyTableViewCell22: UITableViewCell, TableViewCell {
    typealias T = Model
    func upda(_ data: Model) {
        
    }
}
