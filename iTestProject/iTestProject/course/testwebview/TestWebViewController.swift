//
//  TestWebViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

class TestWebViewController: SDJGBaseViewController {

    
    open override class func registerRouterVC(_ urlStr:String)
    {
        SDJGUrlRouterManager.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:urlStr)!) {
                let viewController = TestWebViewController(url: transferURL)
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
    
    
    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.frame = view.frame
        self.view.addSubview(webView)
        webView.delegate = self
    }
    
    // 自定义实现
    init(url:NSURL)
    {
        super.init(nibName: nil, bundle: nil)
        print(url)
        let sss = url.query?.substring(from: "weburl=".endIndex) ?? "http://www.sunlands.com"
//        print(sss)
        
        webView.loadRequest(URLRequest(url: URL(string:sss)!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TestWebViewController:UIWebViewDelegate
{
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}
