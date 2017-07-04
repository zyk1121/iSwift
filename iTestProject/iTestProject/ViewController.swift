//
//  ViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/1.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let btn1 = UIButton(frame: CGRect(x:10,y:100,width:100,height:44))
        btn1.setTitle("测试push", for: [])
        btn1.setTitleColor(UIColor.red, for: [])
        btn1.addTarget(self, action: #selector(test1), for: .touchUpInside)
        self.view.addSubview(btn1)
        
        
        let btn2 = UIButton(frame: CGRect(x:10,y:150,width:100,height:44))
        btn2.setTitle("测试model", for: [])
        btn2.setTitleColor(UIColor.red, for: [])
        btn2.addTarget(self, action: #selector(test2), for: .touchUpInside)
        self.view.addSubview(btn2)
        
        
        let btn3 = UIButton(frame: CGRect(x:10,y:200,width:100,height:44))
        btn3.setTitle("测试-none", for: [])
        btn3.setTitleColor(UIColor.red, for: [])
        btn3.addTarget(self, action: #selector(test3), for: .touchUpInside)
        self.view.addSubview(btn3)
        
        
        let btn4 = UIButton(frame: CGRect(x:10,y:250,width:100,height:44))
        btn4.setTitle("测试web", for: [])
        btn4.setTitleColor(UIColor.red, for: [])
        btn4.addTarget(self, action: #selector(test4), for: .touchUpInside)
        self.view.addSubview(btn4)
        
    }
    
    func test1()
    {
        SDJGUrlRouterManager.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "sdjg://course/main")!, transferType: .push) { (vc, error) in
                        print(vc)
                    }
    }
    
    func test2()
    {
        SDJGUrlRouterManager.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "sdjg://questionlib/main")!, transferType: .model) { (vc, error) in
            print(vc)
        }
    }
    
    func test3()
    {
        SDJGUrlRouterManager.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "sdjg://test/none")!, transferType: .none) { (vc, error) in
//            print(vc)
            vc?.view.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
            self.addChildViewController(vc!)
            vc?.didMove(toParentViewController: self)
            self.view.addSubview((vc?.view)!)
            
        }
    }
    
    func test4()
    {
        // http://www.sunlands.com http://www.baidu.com
        SDJGUrlRouterManager.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "sdjg://test/web?weburl=http://www.sunlands.com")!, transferType: .push) { (vc, error) in
            print(vc)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for v in view.subviews {
            if v.isKind(of: UIButton.self) {
                continue
            }
            v.removeFromSuperview()
        }
        // "sdjg://course/main"
//        SDJGUrlRouterManager.transferFromViewController(sourceViewController: self, toURL: NSURL(string: "sdjg://course/main")!, transferType: .push) { (vc, error) in
//            print(vc)
//        }
    }
}

