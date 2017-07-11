//
//  RXBindUIViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/9.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXBindUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        notiCenter = NotificationCenter.default
    }
    
    var notiCenter:NotificationCenter?
    var test:TestClass = ttt
    
    deinit {
        print(self)
        // 没有对象引用当前对象当前对象就能释放
    }
}

let ttt = TestClass()
class TestClass: NSObject {
    deinit {
        print(self)
    }
}
