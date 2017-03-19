//
//  UIButton+Extension.swift
//  iStudySwift
//
//  Created by zhangyuanke on 16/7/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(imageName: String, backgroundImageName: String) {
        self.init()
        setImage(UIImage(named:imageName), for: UIControlState.normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: UIControlState.highlighted)
        setBackgroundImage(UIImage(named:backgroundImageName), for: UIControlState.normal)
        setBackgroundImage(UIImage(named:backgroundImageName + "_highlighted"), for: UIControlState.highlighted)
        sizeToFit()
    }
}
