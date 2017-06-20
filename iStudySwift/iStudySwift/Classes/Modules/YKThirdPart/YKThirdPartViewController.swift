//
//  YKViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKThirdPartURLString = "yk://istudydemo/thirdpart"

class YKThirdPartViewController: YKTableViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKThirdPartURLString)!) {
                let viewController = YKThirdPartViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKThirdPartURLString)!)
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
        setupData()
        view.setNeedsUpdateConstraints()
    }
    
    private func setupData()
    {
        tableviewData = [["YKText",
                          "123",
                          "456"]]
    }
    
    /// 选中某一行(可以重写)
    override func selectRowAt(indexPath: IndexPath) {
        // 建议重写
        let urlStrs = [kYKYYTextURLString,
                       kYKYYTextURLString,
                       kYKYYTextURLString]
        
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: urlStrs[indexPath.row])!, transferType: .YKTransferTypePush, completion: nil)
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
}
