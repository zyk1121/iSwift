//
//  SDJGCourseRouter.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

public class SDJGCourseRouter : SDJGRegisterRoutersProtocol {
    public static func registerModuleRouters()
    {
        print("注册课程模块")
        SDJGCourseViewController.registerRouterVC("sdjg://course/main")
        TestNoneViewController.registerRouterVC("sdjg://test/none")
        TestWebViewController.registerRouterVC("sdjg://test/web")
    }
}
