//
//  YKPortal.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/14.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit


/// Default Key
fileprivate let kYKDefaultPortalKey = "defaultPortalKey";
fileprivate let kYKPortalErrorDomian = "com.puny.portal";

/// 页面弹出方式 : PUSH & Present
///
/// - YKTransferTypePush: Push
/// - YKTransferTypePresent: Present
enum YKTransferType : Int {
    case YKTransferTypePush = 0
    case YKTransferTypePresent = 1
}

/// Description
typealias YKPortalHandler = (_ URL:NSURL, _ transferType:YKTransferType, _ sourceViewController:UIViewController) -> UIViewController?;

/// MARK:Portal:统一的页面跳转方式
class YKPortal
{
    private static var portalClasses:[AnyClass] = []
    private static var portalMap:Dictionary<String,[YKPortalHandler]> = [:]
    
    /// 注册类（页面）、注册的类会调用initialize方法
    public static func registerClasses()
    {
        // 移除原有的数据
        portalClasses.removeAll()
        portalMap.removeAll()
        // 添加新数据
        portalClasses.append(YKTestViewController.self)
        portalClasses.append(YKTestTableViewController.self)
    }
    
    /// 注册Portal
    ///
    /// - Parameters:
    ///   - handler: 注册block
    ///   - prefixURL: 注册URL
    public static func registerPortalWithHandler(handler:@escaping YKPortalHandler, prefixURL:NSURL)
    {
        let key = keyFromURL(URL: prefixURL)
        let realKey = (key != nil) ? key! : kYKDefaultPortalKey
        
        if (portalMap[realKey] != nil) {
            portalMap[realKey]?.append(handler)
        } else {
            portalMap[realKey] = [YKPortalHandler]()
            portalMap[realKey]?.append(handler)
        }
    }
    
    /// 页面跳转
    ///
    /// - Parameters:
    ///   - sourceViewController: 源VC
    ///   - URL: URL
    ///   - transferType: 页面弹出类型
    ///   - completion: 完成回调
    public static func transferFromViewController(sourceViewController:UIViewController, toURL URL:NSURL, transferType:YKTransferType,completion:((_ viewController:UIViewController?,_ error:NSError?)->Void)?)
    {
        var keysPool:[[String]] = [[String]]()
        let hostKey = keyFromURL(URL: URL)
        if hostKey != nil {
            keysPool.append([hostKey!])
        }
        let leftPossibleKeys:[String]? = extractAllLeftPossibleKeysFromURL(URL: URL)
        if leftPossibleKeys != nil {
            if leftPossibleKeys!.count > 0 {
                keysPool.append(leftPossibleKeys!)
            }
        }
        
        var destinationViewController:UIViewController?
        for itemArray in keysPool {
            let handlers = self._combineHandlerArraysWithKeys(keys: itemArray)
            destinationViewController = self.batchPerformHandlers(handlers: handlers!, withURL: URL, transferType: transferType, withSourceViewController: sourceViewController)
            if destinationViewController != nil {
                break
            }
        }
        
        var portalError:NSError?
        if destinationViewController == nil {
            portalError = NSError.init(domain: kYKPortalErrorDomian, code: -1, userInfo: nil)
        } else {
            
        }
        
        if completion != nil{
            completion!(destinationViewController, portalError)
        }
    }
    private static func _combineHandlerArraysWithKeys(keys:[String]?)->[YKPortalHandler]?
    {
        if keys == nil{
            return nil
        }
        var tempArray:[YKPortalHandler] = [YKPortalHandler]()
        for key in keys! {
            if((portalMap[key] != nil) && (portalMap[key]?.count)! > 0) {
                tempArray += portalMap[key]!
            }
        }
        return tempArray
    }
    
    private static func batchPerformHandlers(handlers:[YKPortalHandler],withURL URL:NSURL,transferType:YKTransferType,withSourceViewController sourceVC:UIViewController)->UIViewController?
    {
        if handlers.count == 0 {
            return nil
        }
        var viewController:UIViewController?
        
        for item in handlers {
            viewController = item(URL, transferType, sourceVC)
            if viewController != nil {
                break
            }
        }
        return viewController
    }
}

/// MARK:NSURL扩展
extension NSURL
{
    public func hasSameTrunkWithURL(URL:NSURL) -> Bool {
        return (self.path == URL.path) && (self.host == URL.host) && (self.scheme == URL.scheme)
    }
}


/// MARK:UIViewController扩展，当前页面是push，还是present过来的
extension UIViewController
{
    /// 当前页面的跳转方式
    var transferType : YKTransferType {
        var transfer : YKTransferType = .YKTransferTypePush
        let vcCounts = self.navigationController?.viewControllers.count;
        if vcCounts == nil {
            transfer = .YKTransferTypePresent
        } else {
            if vcCounts! > 1 && (self.navigationController?.viewControllers.last === self) {
                transfer = .YKTransferTypePush
            } else {
                transfer = .YKTransferTypePresent
            }
        }
        return transfer
    }
    
    /// 返回方法
    func goBack() -> Void {
        if self.transferType.rawValue == 0 {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

/// MARK:全局方法
func keyFromURL(URL:NSURL?)->String?
{
    guard let url = URL else {
        return nil
    }
    return "\(url.scheme!)://\(url.host!)\(url.path!)"
}

func extractAllLeftPossibleKeysFromURL(URL:NSURL?)->[String]?
{
    guard let url = URL else {
        return nil
    }
    var pathItems:[String] = (url.path?.components(separatedBy: "/"))!
    if pathItems.count <= 1 {
        return nil
    }
    pathItems.removeFirst()
    pathItems.removeLast()
    var pathArray:[String] = []
    for item in pathItems {
        let last = pathArray.last
        
        let prefix : String = (last != nil) ? last! : ""
        pathArray.append("\(prefix)/\(item)")
    }
    if pathArray.count <= 0 {
        return nil
    }
    pathArray.reverse()
    
    var results:[String] = []
    // 匹配策略是最长的先被匹配，所以倒序遍历
    for item in pathArray {
        results.append("\(url.scheme!)://\(url.host!)\(item)")
    }
    
    return results
}
