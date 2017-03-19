//
//  UIBarButtonItem+Extension.swift
//  iStudySwift
//
//  Created by zhangyuanke on 16/7/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}
