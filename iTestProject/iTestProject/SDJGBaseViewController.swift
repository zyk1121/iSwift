//
//  SDJGBaseViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

class SDJGBaseViewController: UIViewController {

    open class func registerRouterVC(_ urlStr:String)
    {
        print(self)
        
//        let urlStr = "sdjg://main"
        
        SDJGUrlRouterManager.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceViewController:UIViewController, userInfo:[String:AnyObject]?) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:urlStr)!) {
                let viewController = self.init()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else if transferType.rawValue == 1{
                    sourceViewController.present(viewController, animated: true, completion: nil)
                } else {
                    // none
                    print("none transfer")
                }
                viewController.setUserTransferInfo(userInfo: nil)
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: urlStr)!)
    }
    
    open func setUserTransferInfo(userInfo:[String:Any]?) {
        print(userInfo ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        goBack()
    }
}
