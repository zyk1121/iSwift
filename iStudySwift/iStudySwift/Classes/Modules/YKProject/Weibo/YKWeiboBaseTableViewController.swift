//
//  YKWeiboBaseTableViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

class YKWeiboBaseTableViewController: UITableViewController {
    var userLogin = false
    var visitorView : YKWYKWeiboVisitView?
    override func loadView() {
        userLogin ? super.loadView() : setupVisitView()
    }
    
    private func setupVisitView()
    {
        let visitView = YKWYKWeiboVisitView()
        visitorView = visitView
        view = visitView
    }
}
