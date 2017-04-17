//
//  YKSingleInstance.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/4/5.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

class YKSingleInstance : NSObject
{
    // 用到时才调用init
    static var instance : YKSingleInstance = YKSingleInstance()
    static func sharedYKSingleInstance() -> YKSingleInstance {
        return instance;
    }
    override init() {
        print("------YKSingleInstance init")
    }
}
