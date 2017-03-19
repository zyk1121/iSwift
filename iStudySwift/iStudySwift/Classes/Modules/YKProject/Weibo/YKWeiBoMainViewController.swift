//
//  YKWeiBoMainViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKWeiBoMainURLString = "yk://istudydemo/weibo/main"

class YKWeiBoMainViewController: UITabBarController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKWeiBoMainURLString)!) {
                let viewController = YKWeiBoMainViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKWeiBoMainURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange
        // 添加自子控制器
//        addChildViewController(YKWeiboHomeViewController(),titleName: "首页",imageName: "tabbar_home")
//        addChildViewController(YKWeiboMessageViewController(),titleName: "消息",imageName: "tabbar_message_center")
//        addChildViewController(YKWeiboDiscoverViewController(),titleName: "发现",imageName: "tabbar_discover")
//        addChildViewController(YKWeiboMeViewController(),titleName: "我",imageName: "tabbar_profile")

//        addChildViewController("YKWeiboHomeViewController",titleName: "首页",imageName: "tabbar_home")
//        addChildViewController("YKWeiboMessageViewController",titleName: "消息",imageName: "tabbar_message_center")
//        addChildViewController("YKWeiboDiscoverViewController",titleName: "发现",imageName: "tabbar_discover")
//        addChildViewController("YKWeiboMeViewController",titleName: "我",imageName: "tabbar_profile")
        
        // 通过json创建
        let path  = Bundle.main.path(forResource: "WeiboMainVCSettings.json", ofType: nil)
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            do {
                let dictArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                for dict in dictArr as! [[String:String]] {
                    addChildViewController(dict["vcName"]!, titleName: dict["title"]!, imageName: dict["imageName"]!)
                }
            } catch {
                print(error)
                addChildViewController("YKWeiboHomeViewController",titleName: "首页",imageName: "tabbar_home")
                addChildViewController("YKWeiboMessageViewController",titleName: "消息",imageName: "tabbar_message_center")
                addChildViewController("YKWeiboDiscoverViewController",titleName: "发现",imageName: "tabbar_discover")
                addChildViewController("YKWeiboMeViewController",titleName: "我",imageName: "tabbar_profile")
            }
        }
        
//        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
    }
    
    deinit {
        print("必须执行代码deinit才会调用！")
    }
    
    // 字符串 创建类
    private func addChildViewController(_ childControllerName: String,titleName:String, imageName:String) {
        // 动态获取命名空间
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        let vcCls = cls as! UIViewController.Type
        let childController = vcCls.init()
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.title = titleName
        let navVC = UINavigationController()
        navVC.addChildViewController(childController)
        
        addChildViewController(navVC)
    }
    
//    private func addChildViewController(_ childController: UIViewController,titleName:String, imageName:String) {
//        
//        childController.tabBarItem.image = UIImage(named: imageName)
//        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
//        childController.title = titleName
//        let navVC = UINavigationController()
//        navVC.addChildViewController(childController)
//        
//        addChildViewController(navVC)
//    }
    
    
    /// MARK:返回
    override func goBack() {
        // todo
        super.goBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.goBack()
    }
    
    // MARK:- 自定义view & 布局
    func setupUI() {
        testBtn = UIButton()
        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
        testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(testBtn!)
    }
    override func updateViewConstraints() {
        
        testBtn?.snp_remakeConstraints(closure: { (maker) in
            _ = maker.center.equalTo(view)
        })
        // Call [super updateViewConstraints] as the final step in your implementation.
        super.updateViewConstraints()
    }
    
    // MARK: - event
    func testBtnClicked()
    {
        // testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked), for: UIControlEvents.touchUpInside)
        print("testBtnClicked")
    }
    
    func testBtnClicked(sender:UIButton) {
        print("testBtnClicked(sender:)")
    }
}
