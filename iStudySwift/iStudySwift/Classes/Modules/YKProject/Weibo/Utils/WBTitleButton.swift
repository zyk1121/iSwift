//
//  YKWeiBoTitleButton.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/7/21.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit

class YKWeiBoTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI()
    {
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title! + "  ", for: state)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
            titleLabel?.frame.offsetInPlace(dx: -imageView!.frame.width, dy: 0)
        imageView?.frame.offsetInPlace(dx: titleLabel!.frame.width, dy: 0)
 */
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)!
    }
    
}
