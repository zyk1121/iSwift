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
    
        addViewControllers()
        
//        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
    private func addViewControllers()
    {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 建议在此处设置frame，viewDidLoad中不一定有view以及子views
        super.viewWillAppear(animated)
        
        setupComposeBtn()
    }
    
    private func setupComposeBtn()
    {
        // 添加➕按钮
        tabBar.addSubview(composeBtn)
        let width = UIScreen.main.bounds.width / CGFloat((viewControllers?.count)!)
        let rect = CGRect(x: 2*width, y: 0, width: width, height: 49)
        composeBtn.frame = rect
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
    
    // MARK: - 懒加载
    private lazy var composeBtn : UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(YKWeiBoMainViewController.composeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    // MARK: - event
    // 监听按钮的方法不能是私有方法
    func composeBtnClick() {
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: kYKWeiboPublishURLString)!,transferType: .YKTransferTypePresent) { (destViewController : UIViewController?, error:NSError?) in
            
        }
    }
    func testBtnClicked()
    {
        // testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked), for: UIControlEvents.touchUpInside)
        print("testBtnClicked")
    }
    
    func testBtnClicked(sender:UIButton) {
        print("testBtnClicked(sender:)")
    }
}
