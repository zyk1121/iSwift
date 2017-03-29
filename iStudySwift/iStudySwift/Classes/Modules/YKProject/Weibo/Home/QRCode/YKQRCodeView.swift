//
//  YKQRCodeView.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/28.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class YKQRCodeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.red
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI()
    {
        bgIcon.frame = self.frame
        scanLineIcon.frame = CGRect(x: 0, y: -self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        addSubview(bgIcon)
        addSubview(scanLineIcon)
        // 动画不用自动布局做
//        updateConstraintsIfNeeded()
        
        //
        startAnimation()
    }
    
    // 懒加载
    lazy var bgIcon : UIImageView = UIImageView(image: UIImage(named: "qrcode_border"))
    lazy var scanLineIcon : UIImageView = UIImageView(image: UIImage(named: "qrcode_scanline_qrcode"))
    
    override func updateConstraints() {
//        
//        bgIcon.snp_updateConstraints { (make) in
//            _ = make.edges.equalTo(self)
//        }
//        
//        scanLineIcon.snp_updateConstraints { (make) in
//            _ = make.top.equalTo(self).offset(200)
//            _ = make.left.right.bottom.equalTo(self)
//        }
        
        super.updateConstraints()
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            self.scanLineIcon.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: nil)
    }
    
}
