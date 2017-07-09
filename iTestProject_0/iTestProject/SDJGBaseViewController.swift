//
//  SDJGBaseViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

class SDJGBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        goBack()
    }
    func goBack() -> Void {
        if self.transferType.rawValue == 0 {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 当前页面的跳转方式
    var transferType : SDJGTransfromType {
        var transfer : SDJGTransfromType = .push
        let vcCounts = self.navigationController?.viewControllers.count;
        if vcCounts == nil {
            transfer = .model
        } else {
            if vcCounts! > 1 && (self.navigationController?.viewControllers.last === self) {
                transfer = .push
            } else {
                transfer = .model
            }
        }
        return transfer
    }
    
}
