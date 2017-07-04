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
//        SDJGUrlRouterManager.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceViewController:UIViewController) -> UIViewController? in
//            
//            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kSDJGCourseURLString)!) {
//                let viewController = SDJGCourseViewController()
//                if transferType.rawValue == 0 {
//                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
//                } else {
//                    sourceViewController.present(viewController, animated: true, completion: nil)
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
