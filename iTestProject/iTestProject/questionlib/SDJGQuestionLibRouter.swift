//
//  SDJGQuestionLibRouter.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/4.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

public class SDJGQuestionLibRouter : SDJGRegisterRoutersProtocol {
    public static func registerModuleRouters()
    {
        print("注册题库模块")
        SDJGQuestionLibViewController.registerRouterVC("sdjg://questionlib/main")
    }
}
