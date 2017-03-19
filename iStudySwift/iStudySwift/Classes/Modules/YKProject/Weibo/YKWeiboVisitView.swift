//
//  YKWeiboVisitView.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

class YKWYKWeiboVisitView: UIView {
    
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String) {
        rotationImageView.isHidden = !isHome
        iconImageView.image = UIImage(named: imageName)
        messageLabel.text = message
        
        if isHome {
            startAnimation()
        }
    }
    // MARK: - property
  
    // MARK: - life circle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    
    // 代码布局就不需要xib和storyboard布局了
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 动画
    private func startAnimation()
    {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        rotationImageView.layer.add(anim, forKey: nil)
    }
    
    func setupUI() {
        addSubview(rotationImageView)
        addSubview(maskBgView)
        addSubview(iconImageView)
        addSubview(messageLabel)
        addSubview(rigisterButton)
        addSubview(loginButton)
        
        self.updateConstraints()
    }
    
    // MARK: - 懒加载
    private lazy var rotationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return imageView
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return imageView
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "hello world hello world hello world hello world"
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.lightGray
        return label
    }()
    private lazy var rigisterButton: UIButton = {
        let btn =  UIButton()
        btn.setTitle("注册", for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        let tempImage = UIImage(named:"common_button_white_disable")
        let image = tempImage?.resizableImage(withCapInsets: UIEdgeInsetsMake((tempImage?.size.height)! / 2.0,(tempImage?.size.width)! / 2.0, (tempImage?.size.height)! / 2.0, (tempImage?.size.width)! / 2.0))
        btn.setBackgroundImage(image!, for: UIControlState.normal)
        return btn
    }()
    private lazy var loginButton: UIButton = {
        let btn =  UIButton()
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        let tempImage = UIImage(named:"common_button_white_disable")
        let image = tempImage?.resizableImage(withCapInsets: UIEdgeInsetsMake((tempImage?.size.height)! / 2.0,(tempImage?.size.width)! / 2.0, (tempImage?.size.height)! / 2.0, (tempImage?.size.width)! / 2.0))
        btn.setBackgroundImage(image!, for: UIControlState.normal)
        return btn
    }()
    
    private lazy var maskBgView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return imageView
    }()
    
    // MARK: - autolayout
    override func updateConstraints() {
        super.updateConstraints();
        rotationImageView.snp_updateConstraints { (make) in
            make.center.equalTo(self)
        }
        iconImageView.snp_updateConstraints { (make) in
            make.center.equalTo(self)
        }
        maskBgView.snp_updateConstraints { (make) in
//            make.center.equalTo(self)
            make.edges.equalTo(self)
        }
        messageLabel.snp_updateConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(rotationImageView.snp_bottom)
            make.width.equalTo(224)
        }
        rigisterButton.snp_updateConstraints { (make) in
            make.left.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        loginButton.snp_updateConstraints { (make) in
            make.right.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
}
