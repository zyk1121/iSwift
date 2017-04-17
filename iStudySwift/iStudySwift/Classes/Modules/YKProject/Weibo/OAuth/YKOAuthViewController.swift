//
//  YKOAuthViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/4/9.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKYKOAuthURLString = "yk://istudydemo/weibo/oauth"

class YKYKOAuthViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKYKOAuthURLString)!) {
                let viewController = YKYKOAuthViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKYKOAuthURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
//    var testBtn:UIButton?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_APP_KEY)&redirect_url=\(WB_REDIRECT_URL)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(url: url as! URL)
        webView.loadRequest(request as URLRequest)
        
        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
//        view = webView
    }
    let WB_APP_KEY = "588770173"
    let WB_APP_SECRET = "11fe6d7da4c42514c5f998b8d83d6bef"
    let WB_REDIRECT_URL = "http://www.baidu.com"
    
    private var webView:UIWebView = {
        let webView = UIWebView()
        return webView
    }()
    
    deinit {
//        print("必须执行代码deinit才会调用！")
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
    
    // MARK:- 自定义view & 布局
    func setupUI() {
        view.addSubview(webView)
    }
    override func updateViewConstraints() {
        
        webView.snp_updateConstraints { (make) in
            _ = make.edges.equalTo(view)
        }
        // Call [super updateViewConstraints] as the final step in your implementation.
        super.updateViewConstraints()
    }

}
