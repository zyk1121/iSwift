//
//  YKFFDBViewController.swift
//  iStudySwift
//
//  Created by 张元科 on 2017/6/21.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import YYText
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKFMDBURLString = "yk://istudydemo/thirdpart/fmdb"

class YKFFDBViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKFMDBURLString)!) {
                let viewController = YKFFDBViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKFMDBURLString)!)
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
        setupUI()
        view.setNeedsUpdateConstraints()
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
        testBtn = UIButton()
        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
        testBtn?.addTarget(self, action: #selector(YKFFDBViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
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
