//
//  YKWeiboBaseTableViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

class YKWeiboBaseTableViewController: UITableViewController,YKWYKWeiboVisitViewDelegate {
    var userLogin = true
    var visitorView : YKWYKWeiboVisitView?
    override func loadView() {
        userLogin ? super.loadView() : setupVisitView()
    }
    
    private func setupVisitView()
    {
        let visitView = YKWYKWeiboVisitView()
        visitView.delegate = self
        visitorView = visitView
        view = visitView
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(YKWeiboBaseTableViewController.registerBtnClicked))
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WBBaseTableViewController.loginBtnCliked(_:)))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(YKWeiboBaseTableViewController.loginBtnClicked)),UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.plain, target: self, action: #selector(YKWeiboBaseTableViewController.quitBtnCliked)),]
        
    }
    
    // 登录回调
    func loginBtnClicked()
    {
//        print("登录")
//        print(#function)
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: kYKYKOAuthURLString)!,transferType: .YKTransferTypePresent) { (destViewController : UIViewController?, error:NSError?) in
            
        }
    }
    // 注册回调
    func registerBtnClicked()
    {
        print("注册")
        print(#file)
    }
    
    // 退出
    func quitBtnCliked() {
        self.dismiss(animated: true, completion: nil)
    }
}
