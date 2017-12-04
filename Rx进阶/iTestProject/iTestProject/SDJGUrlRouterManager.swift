//
//  SDJGUrlRouterManager.swift
//
//  Created by 张元科 on 2017/7/5.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import Foundation

/** 
 SDJGUrlRouterManager.swift
 
 1> 实现功能：URLRoute，注册需要支持URL跳转的页面，实现根据不同的方式（push，model等方式）展示页面VC
 2> 注册入口：registerRouters方法，会在App Launch的时候调用；内部会调用不同模块的注册方法，每个模块需要一个类实现SDJGRegisterRoutersProtocol协议，并在registerModuleRouters方法中注册自己的VC和Method；同时在routerModules属性中添加实现了该协议的类，注意添加类的前缀（命名空间）
 3> 命名规则：sdjg://模块名/二级目录/三级目录/..?parameter=XXX
            栗子:sdjg://sdjgcourseproject/courselist/coursedetail
                sdjg://sdjgquestionbankproject/subjectdetail
                sdjg://xxx/setting/about/?parameter=123
 4> 注意事项：默认UIViewController已经实现了registerRouterVC方法，内部使用init()初始化，需要自定义构造器的可以重写该方法，内部修改即可
 */

// 页面跳转类型（其中none只是创建了页面并未进行跳转，满足添加子控制器的需求）
public enum SDJGTransfromType : Int {
    case push       = 0
    case model      = 1
    case none       = 2
}

// 每个模块需要实现一个该协议的类，用于模块内部VC和method的注册
public protocol SDJGRegisterRoutersProtocol {
    static func registerModuleRouters()
}

// 用于注册VC Router的闭包定义，会在页面跳转的时候执行闭包
public typealias SDJGRouterHandler = (_ URL:NSURL, _ transferType:SDJGTransfromType, _ sourceVC:UIViewController, _ userInfo:[String:AnyObject]?) -> UIViewController?

// 用于注册Method的闭包定义，会在执行方法的时候执行闭包
public typealias SDJGMethodHandler = (_ param:Any?)->(Any?)

// MARK: - 统一的页面跳转方式
public class SDJGUrlRouterManager
{
    // 模块实现的注册router的类名称
    private static let routerModules:[String] = ["iTestProject.RXSwiftRouter"]
    private static var routerMap:Dictionary<String,[SDJGRouterHandler]> = [:]
    private static var methodMap:Dictionary<String,SDJGMethodHandler> = [:]
    
    /* 路由注册的入口，需要在didFinishLaunchingWithOptions中调用 */
    public static func registerRouters()
    {
        routerMap.removeAll()
        methodMap.removeAll()
        
        for item in routerModules {
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
    // MARK:页面Router注册以及调用方法
    public static func registerRouterWithHandler(handler:@escaping SDJGRouterHandler, prefixURL:NSURL)
    {
        let key = keyFromURL_router(URL: prefixURL)
        let realKey = (key != nil) ? key! : kSDJGDefaultPortalKey
        
        if (routerMap[realKey] != nil) {
            routerMap[realKey]?.append(handler)
        } else {
            routerMap[realKey] = [SDJGRouterHandler]()
            routerMap[realKey]?.append(handler)
        }
    }
    
    // router
    public static func router(sourceVC:UIViewController, toURL URL:NSURL, transferType:SDJGTransfromType = .push,userInfo:[String:AnyObject]? = nil,completion:((_ viewController:UIViewController?,_ error:NSError?)->Void)? = nil)
    {
        var keysPool:[[String]] = [[String]]()
        let hostKey = keyFromURL_router(URL: URL)
        if hostKey != nil {
            keysPool.append([hostKey!])
        }
        let leftPossibleKeys:[String]? = extractAllLeftPossibleKeysFromURL_router(URL: URL)
        if leftPossibleKeys != nil {
            if leftPossibleKeys!.count > 0 {
                keysPool.append(leftPossibleKeys!)
            }
        }
        
        var destinationViewController:UIViewController?
        for itemArray in keysPool {
            let handlers = self._combineHandlerArraysWithKeys(keys: itemArray)
            destinationViewController = self.batchPerformHandlers(handlers: handlers!, withURL: URL, transferType: transferType, withSourceViewController: sourceVC,userInfo: userInfo)
            if destinationViewController != nil {
                break
            }
        }
        
        var portalError:NSError?
        if destinationViewController == nil {
            portalError = NSError.init(domain: kSDJGRouterErrorDomian, code: -1, userInfo: nil)
        } else {
        }
        
        if completion != nil{
            completion!(destinationViewController, portalError)
        }
    }
    
    // MARK:页面Method注册以及调用方法
    public static func registerMethodWithHandler(handler:@escaping SDJGMethodHandler, prefixURL:NSURL)
    {
        let key = keyFromURL_router(URL: prefixURL)
        let realKey = (key != nil) ? key! : kSDJGDefaultMethodKey
        methodMap[realKey] = handler
    }
    
    // method call
    public static func callMethod(withURL:NSURL,param:Any?,completion:((_ result:Any?,_ error:NSError?)->Void)?) {
        let key = keyFromURL_router(URL: withURL)
        let realKey = (key != nil) ? key! : kSDJGDefaultMethodKey
        guard let methodHandler = methodMap[realKey] else {
            if completion != nil {
                let methodError = NSError.init(domain: kSDJGMethodErrorDomian, code: -1, userInfo: nil)
                completion!(nil,methodError)
            }
            return
        }
        let result = methodHandler(param)
        
        if completion != nil {
            completion!(result,nil)
        }
    }
    
    // MARK:私有类方法
    private static func _combineHandlerArraysWithKeys(keys:[String]?)->[SDJGRouterHandler]?
    {
        if keys == nil {
            return nil
        }
        var tempArray:[SDJGRouterHandler] = [SDJGRouterHandler]()
        for key in keys! {
            if((routerMap[key] != nil) && (routerMap[key]?.count)! > 0) {
                tempArray += routerMap[key]!
            }
        }
        return tempArray
    }
    
    private static func batchPerformHandlers(handlers:[SDJGRouterHandler],withURL URL:NSURL,transferType:SDJGTransfromType,withSourceViewController sourceVC:UIViewController,userInfo:[String:AnyObject]?)->UIViewController?
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

// MARK: - 全局方法
func keyFromURL_router(URL:NSURL?)->String?
{
    guard let url = URL else {
        return nil
    }
    return "\(url.scheme!)://\(url.host!)\(url.path!)"
}

func extractAllLeftPossibleKeysFromURL_router(URL:NSURL?)->[String]?
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


// MARK: - NSURL扩展
extension NSURL
{
    public func hasSameTrunkWithURL(URL:NSURL) -> Bool {
        return (self.path == URL.path) && (self.host == URL.host) && (self.scheme == URL.scheme)
    }
}

// MARK: - UIViewController扩展(Router & Method)
extension UIViewController {
    
    // VC注册，子类需要的话可以重写
    open class func registerRouterVC(_ routerURL:String)
    {
        guard let tempRouterURL = NSURL(string:routerURL) else {
            return
        }
        SDJGUrlRouterManager.registerRouterWithHandler(handler: { (transferURL:NSURL, transferType:SDJGTransfromType, sourceVC:UIViewController, userInfo:[String:AnyObject]?) -> UIViewController? in
            if transferURL.hasSameTrunkWithURL(URL: tempRouterURL) {
                let viewController = self.init()
                if transferType == .push {
                    sourceVC.navigationController?.pushViewController(viewController, animated: true)
                } else if transferType == .model {
                    sourceVC.present(viewController, animated: true, completion: nil)
                } else {
                }
                viewController.setRouterInfo(userInfo: userInfo)
                return viewController
            } else {
                return nil
            }
        }, prefixURL: tempRouterURL)
    }
    // 子类需要处理userinfo的时候重写
    open func setRouterInfo(userInfo:[String:Any]?) {
        
    }
    // 方法注册，子类需要的话可以重写
    open static func registerMethod(methodURL:String) {
        guard let tempMethodURL = NSURL(string:methodURL) else {
            return
        }
        SDJGUrlRouterManager.registerMethodWithHandler(handler: { (param:Any?) -> (Any?) in
            return self.callRouterMethod(param: param)
        }, prefixURL: tempMethodURL)
    }
    // 默认执行的方法调用，子类需要的话可以重写
    open static func callRouterMethod(param:Any?) -> Any? {
        return nil
    }
}

// MARK: - 私有定义
// 默认注册Portal的Key
fileprivate let kSDJGDefaultPortalKey = "defaultPortalKeySDJG";
// 默认注册Method的Key
fileprivate let kSDJGDefaultMethodKey = "defaultMethodKeySDJG";
// Router默认错误Domain
fileprivate let kSDJGRouterErrorDomian = "com.sunlands.router.error";
// Method默认错误Domain
fileprivate let kSDJGMethodErrorDomian = "com.sunlands.method.error";

