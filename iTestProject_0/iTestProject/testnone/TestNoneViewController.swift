//
//  TestNoneViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

class TestNoneViewController: SDJGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.orange
    }

    public static func registerMethod(withURL:String) {
        SDJGUrlRouterManager.registerMethodWithHandler(handler: { (param:Any?) -> (Any?) in
            print(param)
            
            let t = TestObject()
            print(t.test())
            
            return "hello"
        }, prefixURL: NSURL(string: withURL)!)
    }
    
    
    
}

class TestObject: NSObject {
    public func test()->String {
        return "1234"
    }
}
