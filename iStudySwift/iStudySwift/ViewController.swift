//
//  ViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/14.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "iSwift"
//        print(self.navigationItem.title ?? "123")
        self.view.backgroundColor = UIColor.white
        // 返回按钮
        let returenButtonItem = UIBarButtonItem()
        returenButtonItem.title = "返回"
        self.navigationItem.backBarButtonItem = returenButtonItem
    }
    
    // 点击页面
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        let test = Test()
//        self.navigationController?.pushViewController(test, animated: true)
//        
//        YKPortal.registerPortalWithHandler(handler: { (URL, transferType, sourceViewController) -> UIViewController in
//            return Test()
//        }, prefixURL: NSURL(string: "ddd")!)
    }
}



class Test: UIViewController {
    static func portalLoad()
    {
        print("portalLoad")
         print("portalLoad2")
    }
     public override class func initialize()
     {
         portalLoad()
    
    }
}
