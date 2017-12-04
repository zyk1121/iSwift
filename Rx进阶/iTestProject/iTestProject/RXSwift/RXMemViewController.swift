//
//  RXMemViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/12/3.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXMemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        testMemory()
    }
    
    var disposeBag = DisposeBag()
    
    func testMemory()
    {
        let requestObservable = { () -> Observable<Int> in
            return Observable.create({ (observer) -> Disposable in
                // AnyObserver<Element> -> Disposable (AnyObserver<Element>事件源)
                print("模拟异步任务开始...")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    observer.on(.next(1))
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    observer.on(.next(2))
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    observer.on(.next(3))
                    observer.on(.completed)
                })
//                return Disposables.create()// NopDisposable
                return Disposables.create {
                    print("用户自定义清理资源的block")
                }
            })
        }
        
        let dispose = requestObservable().subscribe {[weak self] (event) in
            self?.logContent(event: event)
        }
        dispose.addDisposableTo(disposeBag)
    }
    
    func logContent(event:Event<Int>) {
        print(event)
    }
    
    deinit {
        print(self)
    }
}
