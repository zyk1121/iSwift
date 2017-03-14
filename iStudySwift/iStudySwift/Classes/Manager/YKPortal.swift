//
//  YKPortal.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/14.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

// 页面弹出方式 : PUSH & Present
enum YKTransferType : Int {
    case YKTransferTypePush = 0
    case YKTransferTypePresent = 1
}

// 注册Block
typealias YKPortalHandler = (_ URL:NSURL, _ transferType:YKTransferType, _ sourceViewController:UIViewController) -> UIViewController;

//MARK:传输门
class YKPortal : NSObject
{
    var test = Test()
    
    // 注册传输门
    static func registerPortalWithHandler(handler:YKPortalHandler, prefixURL:NSURL)
    {
        
    }
    
    // 传输门跳转
    static func transferFromViewController(sourceViewController:UIViewController, toURL URL:NSURL, transferType:YKTransferType,completion:(_ viewController:UIViewController,_ error:NSError)->Void)
    {
    
    }
    
    
    

    
}

//MARK:NSURL扩展
extension NSURL
{
    func hasSameTrunkWithURL(URL:NSURL) -> Bool {
        return (self.path == URL.path) && (self.host == URL.host) && (self.scheme == URL.scheme)
    }
}
