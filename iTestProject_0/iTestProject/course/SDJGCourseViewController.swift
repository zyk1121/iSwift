//
//  SDJGCourseViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SDJGCourseViewController: SDJGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        print("\n")
        test2()
    }
    
    let disBag:DisposeBag = DisposeBag()
    
    var label:UILabel? = nil
    
    func test2() {
        /*
        Observable<Int>.never().subscribe { (event) in
            print("hahha ")
        }.addDisposableTo(disBag)
 */
        /*
        Observable<Int>.empty().subscribe { (event) in
            self.testcall()
            print(event)
        }.addDisposableTo(disBag)
         */
        /*
        let disposeBag = DisposeBag()
        Observable<Int>.error(glGetError().test)
            .subscribe { print($0) }
            .addDisposableTo(disposeBag)
 */
        /*
        Observable<Int>.just(1).subscribe { (event) in
            self.testcall()
            print(event)
        }.addDisposableTo(disBag)
 */
        /*
        Observable.from(["1", "2", "3", "4"]).subscribe { (event) in
            print(event)
        }.addDisposableTo(disBag)
 */
        /*
        Observable<Int>.repeatElement(1).take(4).subscribe { (event) in
            print(event)
        }.addDisposableTo(disBag)
 */
        /*
        
        let hahh = {()->() in
            print("cccccccc")
            print("dispose")
            return
        }
        let myJust = {(element:String)->Observable<String> in
                return Observable.create({ (observe) -> Disposable in
                    observe.onNext(element)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
                        observe.onNext(element)
                    }
                    
                    observe.onNext(element)
                    observe.onNext(element)
                    observe.onCompleted()
                    return Disposables.create(with: hahh)
                })
        }
dis = myJust("dd").subscribe { (enent) in
    print(enent)
//    self.testcall()
        }
        
        dis2 = myJust("dd333").subscribe { (enent) in
            print(enent)
//            self.testcall()
        }
        dis2?.addDisposableTo(disBag)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) { 
            self.dis?.dispose()
        }
 
 */
        
        /*
        
        let sub = PublishSubject<Int>()
        sub.subscribe { (event) in
            print(event)
        }
      
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            sub.onNext(12)
            
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                sub.onNext(13)
                sub.onCompleted()
            }
           
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            
            sub.subscribe({ (event) in
                print(event)
            })
        }
 
 */
        
        /*
        http://blog.csdn.net/zzdjk6/article/details/52264687
         
//        var value = Variable<String>("hello")
        
//        var hahaValue = Variable<String>("hello")
        hahaValue.asObservable().subscribe { (event) in
            print(event)
        }
        hahaValue.value = "123"
//        backgroundScheduler
//        MainScheduler.instance
    
        
 */
        
        /*
        
        //        var value = Variable<String>("hello")
        
        //        var hahaValue = Variable<String>("hello")
        hahaValue.value = "1"
        hahaValue.asObservable().subscribe { (event) in
            print(event)
        }
        hahaValue.value = "2"
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.hahaValue.asObservable().subscribe { (event) in
                print(event)
            }
        }
        
        hahaValue.value = "3"
        // 输出 1 2 3、 3（热信号初始订阅的是上一次赋值或者改变的值）
       
        //        backgroundScheduler
        //        MainScheduler.instance
 
 */
        
        /*
         
         sequence1
         .observeOn(backgroundScheduler)
         .map { n in
         print("This is performed on the background scheduler")
         }
         .observeOn(MainScheduler.instance)
         .map { n in
         print("This is performed on the main scheduler")
         }.subscribeOn(backgroundScheduler)
         .subscribeNext{ n in
         print("This is performed on the background scheduler")
  
         */
        
        /*
         
         23
         共享监听Sharing subscription－shareReplay
         
         这个是很常用的，比如一个Obserable用做网络请求，通常，当你这样调用的时候，会创建两个序列，也就是会进行两次网络请求，这是不需要的
         
         let network = networkWithText(text)
         let subscription1 = network
         .subscribeNext { n in
         //创建第一个序列
         }
         let subscription2 = network
         .subscribeNext { n in
         //创建第二个序列
         }
         1
         2
         3
         4
         5
         6
         7
         8
         9
         1
         2
         3
         4
         5
         6
         7
         8
         9
         为了共享一个序列，你只需要这这样调用
         
         let network = networkWithText(text).shareReplay(1)
         */
        
        /*
        let disposeBag = DisposeBag()
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
 
 */
        
        /*
        
        let disposeBag = DisposeBag()
        
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) }, onError: { print("Intercepted error:", $0) }, onCompleted: { print("Completed")  })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
 */
        
        /*
         let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        
//        subject.asObserver("1").disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱")
        
//        subject.addObserver("2").disposed(by: disposeBag)
        subject.onNext("🅰️")
        subject.onNext("🅱️")
 */
        
        /*
         
         
         ReplaySubject
         
         Broadcasts new events to all subscribers, and the specified bufferSize number of previous events to new subscribers.
         
         /*:
         > This example also introduces using the `onNext(_:)` convenience method, equivalent to `on(.next(_:)`, which causes a new Next event to be emitted to subscribers with the provided `element`. There are also `onError(_:)` and `onCompleted()` convenience methods, equivalent to `on(.error(_:))` and `on(.completed)`, respectively.
         ----
         ## ReplaySubject
         Broadcasts new events to all subscribers, and the specified `bufferSize` number of previous events to new subscribers.
         ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
         */
         example("ReplaySubject") {
         let disposeBag = DisposeBag()
         let subject = ReplaySubject<String>.create(bufferSize: 1)
         
         subject.addObserver("1").disposed(by: disposeBag)
         subject.onNext("🐶")
         subject.onNext("🐱")
         
         subject.addObserver("2").disposed(by: disposeBag)
         subject.onNext("🅰️")
         subject.onNext("🅱️")
         }
         
         ReplaySubject
         
         Broadcasts new events to all subscribers, and the specified bufferSize number of previous events to new subscribers.
         
         */
        
        /*
        let disposeBag = DisposeBag()
        
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .startWith("1️⃣")
            .startWith("2️⃣")
            .startWith("3️⃣", "🅰️", "🅱️")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
 
 */
        
        /*
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("🅰️")
        
        subject1.onNext("🅱️")
        
        subject2.onNext("①")
        
        subject2.onNext("②")
        
        subject1.onNext("🆎")
        
        subject2.onNext("③")
 */
        /*
        let disposeBag = DisposeBag()
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")
        
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        
        stringSubject.onNext("🆎")
        intSubject.onNext(3)
 */
        
        /*
        let disposeBag = DisposeBag()
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        stringSubject.onNext("🅰️")
        
        stringSubject.onNext("🅱️")
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        
        stringSubject.onNext("🆎")
 */
        
        /*
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        _ = interval
            .subscribe(onNext: { print("Subscription: 1, Event: \($0)") })
        
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("Subscription: 2, Event: \($0)") })
        }
 */
        
    }
    
    var hahaValue = Variable<String>("hello")
    
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//    
//    })
//    
    
    
    
    func test() {
        label = UILabel()
        label?.frame  = CGRect(x: 0, y: 100, width: 100, height: 40)
        label?.text = "1234"
        label?.textColor = UIColor.red
        view.addSubview(label!)
        
//        exampleOf("just") {
//            Observable.just(32)
//                .subscribe {
//                    print($0)
//            }
//        }
        
        print("1")
//        _ = Observable.just("1234").subscribe { (event) in
//            print(event)
//            print(event.element ?? "")
//        }
//        Observable.just(123).subscribe(onNext: { (next) in
//            print(next)
//        }, onError: { (error) in
//            print(error)
//        }, onCompleted: { 
//            print("com")
//        }) { 
//            print("dispos")
//        }
//        Observable.of(1, 2, 3, 4, 5)
//            .subscribeOn               print($0)
//            }
//            .dispose()
        
        // 没有循环引用
//        dis =  Observable.of(1,2,3).subscribe { (event) in
//            self.testcall()
//            print(event)
//        }
        
        
//        dis = NotificationCenter.default.rx.notification(NSNotification.Name("hhehh"), object: nil).subscribe { (event) in
//            self.testcall()
//            print(event)
//        }
//        dis?.addDisposableTo(disBag)
//        
//        NotificationCenter.default.rx.base.addObserver(forName: <#T##NSNotification.Name?#>, object: <#T##Any?#>, queue: <#T##OperationQueue?#>, using: <#T##(Notification) -> Void#>)
//        
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
//            NotificationCenter.default.post(name: NSNotification.Name("hhehh"), object: self, userInfo: ["123":"234"])
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
////            self.dis?.dispose()
//        }
//        
//        NotificationCenter.default.rx.base.post(name: NSNotification.Name("hhehh"), object: nil, userInfo: ["123":"234"] )
//        dd.addDisposableTo(disBag)
        
        print("2")
    }
    
    var dis:Disposable?
    var dis2:Disposable?
    
    
    func testcall() {
        print(#function)
    }
    
    
    func exampleOf(_ description: String, action: (Void) -> Void) {
        print("\n--- Example of:", description, "---")
        action()
    }
    
    deinit {
        print("deinit" + String(describing: self.classForCoder) + String(self.hash))
    }
    
}
