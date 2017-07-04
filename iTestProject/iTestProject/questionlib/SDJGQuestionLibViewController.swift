//
//  SDJGQuestionLibViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

//fileprivate let kSDJGQuestionURLString = "sdjg://questionlib/main"

class SDJGQuestionLibViewController: SDJGBaseViewController {

    open override class func registerRouterVC(_ urlStr:String)
    {
        SDJGUrlRouterManager.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceViewController:UIViewController, userInfo:[String:AnyObject]?) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:urlStr)!) {
                let viewController = SDJGQuestionLibViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: urlStr)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
    }
}
