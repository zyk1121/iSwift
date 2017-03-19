//
//  SSLog.swift
//  iStudySwift
//
//  Created by zhangyuanke on 16/7/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import UIKit

// http://www.tuicool.com/articles/iQ3Ev2U

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

var SSLogEnabled = false

// 泛型函数
func SSLog<T>(message: T, fileName: String = #file, funcName: String = #function, lineNum: Int = #line) {
    /*
    if SSLogEnabled {
        let _fileName = fileName.componentsSeparatedByString("/").last!
        print("\(_fileName)~\(funcName)~[\(lineNum)]~~~:\(message)")
    }*/
    
    // buildsetting->输入 custom + "D DEBUG"
    #if DEBUG
//        let _fileName = fileName.componentsSeparatedBy(by: "/").last!
//        print("\(_fileName)~\(funcName)~[\(lineNum)]~~~:\(message)")
    #endif
}

/*
 
 
 方式1
 
 在 Swift 中，虽然没有了在 Object-C 预处理（preprocessor），但是依然可以使用相似的东西，在 Swift 中叫做 build configurations，当然功能上和预处理不是同一个级别的。
 
 于是在 Swift 中，你可以这样使用：
 
 #if build configuration
 statements
 #else
 statements
 #endif
 而这里的 build configuration 则需要手动的在 Xcode 中进行设置，比如在 Objc 项目中会有预定义的宏 DEBUG ，而在 Swift 中，你如果希望这样使用：
 
 #if DEBUG
 statements
 #else
 statements
 #endif
 你就必须在 Xcode 中的 Build Settings 里找到 Swift Compiler - Custom Flags 这个 Section，然后在其中添加一条 -D DEBUG
 
 如果你实在希望有个图的话，可以直接打开这个回答 answer-36502874
 
 如你所见，这个方式和我们原本在 Objc 中的方式很相似，但是设置 Custom Flags 的步骤也是稍显繁琐了。
 */
