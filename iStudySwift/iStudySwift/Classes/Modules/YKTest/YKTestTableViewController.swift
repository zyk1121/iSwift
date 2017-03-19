//
//  YKTestTableView.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

let kYKTestTableViewURLString = "yk://istudydemo/test/tableview"

/// 测试类
class YKTestTableViewController: YKTableViewController {
    
    /// MARK:Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKTestTableViewURLString)!) {
                let viewController = YKTestTableViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKTestTableViewURLString)!)
    }
    /// MARK:initialize
    public override class func initialize()
    {
        portalLoad()
    }
    
    deinit {
        print("必须执行代码deinit才会调用！")
    }
    
    /// MARK:viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 重新设置tableView数据
//        self.tableviewData = [["123","345"],["abc","def"]]

        self.tableviewData = [["123","345"],["abc","def"],["hahaha"]]
        
        self.tableviewData = [["123","345"],["abc","def"],["hahaha"]]
        self.tableSectionHeaderData = ["A","B","C"]
    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
    }
    
    /// MARK:返回
    override func goBack() {
        // todo
        super.goBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.goBack()
    }
}
