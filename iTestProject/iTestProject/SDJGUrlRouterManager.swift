//
//  SDJGUrlRouterManager.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import Foundation

// private Key
fileprivate let kSDJGDefaultPortalKey = "defaultPortalKey_SDJG";
fileprivate let kSDJGPortalErrorDomian = "com.sunlands.portal";

// transform type
public enum SDJGTransfromType : Int {
    case push
    case model
    case none
}

public protocol SDJGRegisterRoutersProtocol {
    static func registerModuleRouters()
}

/// Description
public typealias SDJGPortalHandler =
    (_ URL:NSURL,
    _ transferType:SDJGTransfromType,
    _ sourceViewController:UIViewController,
    _ userInfo:[String:AnyObject]?) -> UIViewController?
public typealias SDJGRegisterModuleHandler = ()->()

/// MARK:Router统一的页面跳转方式
public class SDJGUrlRouterManager
{
    private static let portalModules:[String] = ["iTestProject.SDJGQuestionLibRouter",
                                                 "iTestProject.SDJGCourseRouter"]
    private static var portalMap:Dictionary<String,[SDJGPortalHandler]> = [:]
    
    // 注册App路由
    public static func registerRouters()
    {
        portalMap.removeAll()
        
        for item in portalModules {
            guard let registerModule = NSClassFromString(item) else {
                print("注册的模块:\(item) 不存在")
                continue
            }
            
            guard let registerClass = registerModule as? SDJGRegisterRoutersProtocol.Type else {
                print("注册的模块:\(item) 需要实现[SDJGRegisterRoutersProtocol]协议")
                continue
            }
            
            registerClass.registerModuleRouters()
        }
    }
    
    /// 注册Portal
    ///
    /// - Parameters:
    ///   - handler: 注册block
    ///   - prefixURL: 注册URL
    public static func registerPortalWithHandler(handler:@escaping SDJGPortalHandler, prefixURL:NSURL)
    {
        let key = keyFromURL(URL: prefixURL)
        let realKey = (key != nil) ? key! : kSDJGDefaultPortalKey
        
        if (portalMap[realKey] != nil) {
            portalMap[realKey]?.append(handler)
        } else {
            portalMap[realKey] = [SDJGPortalHandler]()
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
    public static func transferFromViewController(sourceViewController:UIViewController, toURL URL:NSURL, transferType:SDJGTransfromType = .push,userInfo:[String:AnyObject]? = nil,completion:((_ viewController:UIViewController?,_ error:NSError?)->Void)? = nil)
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
            destinationViewController = self.batchPerformHandlers(handlers: handlers!, withURL: URL, transferType: transferType, withSourceViewController: sourceViewController,userInfo: userInfo)
            if destinationViewController != nil {
                break
            }
        }
        
        var portalError:NSError?
        if destinationViewController == nil {
            portalError = NSError.init(domain: kSDJGPortalErrorDomian, code: -1, userInfo: nil)
        } else {
            
        }
        
        if completion != nil{
            completion!(destinationViewController, portalError)
        }
    }
    private static func _combineHandlerArraysWithKeys(keys:[String]?)->[SDJGPortalHandler]?
    {
        if keys == nil{
            return nil
        }
        var tempArray:[SDJGPortalHandler] = [SDJGPortalHandler]()
        for key in keys! {
            if((portalMap[key] != nil) && (portalMap[key]?.count)! > 0) {
                tempArray += portalMap[key]!
            }
        }
        return tempArray
    }
    
    private static func batchPerformHandlers(handlers:[SDJGPortalHandler],withURL URL:NSURL,transferType:SDJGTransfromType,withSourceViewController sourceVC:UIViewController,userInfo:[String:AnyObject]?)->UIViewController?
    {
        if handlers.count == 0 {
            return nil
        }
        var viewController:UIViewController?
        
        for item in handlers {
            viewController = item(URL, transferType, sourceVC,userInfo)
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
