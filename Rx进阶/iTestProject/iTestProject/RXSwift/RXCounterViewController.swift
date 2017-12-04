//
//  RXCounterViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/12/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXCounterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
//        counter1(num: 3)
//        counter2(num: 3)
        counter3(num: 3)
    }
    
    var disposeBag = DisposeBag()

    // 计数器 😭
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
    
    // 计数器 😭
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
    
    // 计数器 😄
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
}
