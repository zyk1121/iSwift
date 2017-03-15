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
//        }, prefixURL: NSURL(string: "ishowmap://ishowmap/test")!)
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "ishowmap://ishowmap/test")!,transferType: YKTransferType(rawValue: 0)!) { (vc, error) in
            print("hello www:")
        }
    }
}



class Test: UIViewController {
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (URL, transferType, sourceViewController) -> UIViewController in
            let vc = Test()
            sourceViewController.navigationController?.pushViewController(vc, animated: true)
            return vc
        }, prefixURL: NSURL(string: "ishowmap://ishowmap/test")!)
    }
     public override class func initialize()
     {
         portalLoad()
        
    }

    
}
