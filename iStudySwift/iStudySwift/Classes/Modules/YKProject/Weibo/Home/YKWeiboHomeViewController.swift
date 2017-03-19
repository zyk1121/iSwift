//
//  YKWeiboHomeViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKWeiboHomeURLString = "yk://istudydemo/weibo/home"

class YKWeiboHomeViewController: YKWeiboBaseTableViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKWeiboHomeURLString)!) {
                let viewController = YKWeiboHomeViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKWeiboHomeURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    
    var titleButton:YKWeiBoTitleButton?
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            visitorView!.setupVisitorInfo(isHome: true, imageName: "visitordiscover_feed_image_house", message: "1234567")
        } else {
            setupNavi()
            setupTitle()
        }
        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
    // 初始化左右按钮
    private func setupNavi()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightBarButtonClick))
    }
    
    // 初始化标题按钮
    private func setupTitle()
    {
        let tileBtn = YKWeiBoTitleButton()
        tileBtn.setTitle("abcd ", for: UIControlState.normal)
        tileBtn.setTitle("abcd ", for: UIControlState.selected)
        tileBtn.addTarget(self, action: #selector(titleBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        titleButton = tileBtn
        navigationItem.titleView = tileBtn
    }
    
    //
    func titleBtnClicked(sender:YKWeiBoTitleButton) {
        sender.isSelected = !sender.isSelected;
    }
    
    func leftBarButtonClick() {
        print(#function)
    }
    
    func rightBarButtonClick()
    {
        print(#function)
    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
    }
    
    deinit {
        print("必须执行代码deinit才会调用！")
    }
    
    /// MARK:返回
    override func goBack() {
        // todo
        super.goBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.goBack()
    }
    
    // MARK:- 自定义view & 布局
    func setupUI() {
//        testBtn = UIButton()
//        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
//        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
//        testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(testBtn!)
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
