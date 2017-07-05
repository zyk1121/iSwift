//
//  SDJGCourseViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

//fileprivate let kSDJGCourseURLString = "sdjg://course/main"
class SDJGCourseViewController: SDJGBaseViewController {

//    open override class func registerRouterVC()
//    {
//        SDJGUrlRouterManager.registerRouterWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceVC:UIViewController) -> UIViewController? in
//            
//            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kSDJGCourseURLString)!) {
//                let viewController = SDJGCourseViewController()
//                if transferType.rawValue == 0 {
//                    sourceVC.navigationController?.pushViewController(viewController, animated: true)
//                } else {
//                    sourceVC.present(viewController, animated: true, completion: nil)
//                }
//                
//                return viewController
//            } else {
//                return nil
//            }
//        }, prefixURL: NSURL(string: kSDJGCourseURLString)!)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
    }
    
    
}
