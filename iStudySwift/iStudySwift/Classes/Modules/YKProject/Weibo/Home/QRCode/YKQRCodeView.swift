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

//// 二维码类型
//enum QRCodeType {
//    case QRCode// 二维码
//    case BarCode// 条形码
//}

class YKQRCodeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.clear
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
    
    override var frame: CGRect {
        set {
            super.frame = newValue
            setupUI()
        }
        get {
            return super.frame
        }
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
        self.scanLineIcon.layer.removeAllAnimations()
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            self.scanLineIcon.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//            print("1234")// 执行一次
        }, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    /**
     - logo
     - parameter surperImage: 二维码
     - parameter subImage:    logo
     - parameter postRext:    logo位置
     - returns: 返回加上logo的图片
     */
//    private func imageViewAddImage(surperImage: UIImage, subImage: UIImage, postRect:CGRect) -> UIImage
//    {
//        //// 创建图像
//        UIGraphicsBeginImageContext(surperImage.size);
//        
//        //// 设置坐标
//        surperImage.draw(in: CGRect(x:0, y:0, width: surperImage.size.width, height: surperImage.size.height));
//        
//        surperImage.draw(in: postRect);
//        
//        //// 返回一个图像基于当前位图图形
//        let newImage = UIGraphicsGetImageFromCurrentImageContext();
//        
//        //// 移除当前位图图形
//        UIGraphicsEndImageContext();
//        
//        return newImage!;
//    }
    
    /**
     调整大小
     - parameter ciImage: 待改变的image
     - parameter width:   设置比例系数
     - returns: 设置比例后的图片
     */
//    private func SetSize(ciImage: CIImage, _width:CGFloat) -> UIImage
//    {
//        let extent = ciImage.extent.integral;
//        let scale = min(_width / extent.width, _width / extent.height);
//        
//        let width = extent.width * scale;
//        let height = extent.height * scale;
//        
//        let cs = CGColorSpaceCreateDeviceGray();
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue);
//        
//        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: bitmapInfo.rawValue);
//        
//        let context = CIContext(options: [kCIContextUseSoftwareRenderer:(true)]);
//        let bitmapImage = context.createCGImage(ciImage, from: extent);
//        
//        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
//        bitmapRef!.scaleBy(x: scale, y: scale)
//        
//        CGContextDrawImage(bitmapRef, extent, bitmapImage);
//        
//        let scaledImage = bitmapRef!.makeImage();
//        
//        return UIImage(cgImage: scaledImage!);
//    }
//    
    
    /**
     截取logo边角
     - parameter cornerRadius: 截取度
     - parameter image:        需要截取边角的图片
     - returns: 截取边角后的图片
     */
//    private func ImageAfterCutOutCorner(cornerRadius:CGFloat, image:UIImage) -> UIImage
//    {
//        let frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0);
//        UIBezierPath.init(roundedRect:frame, cornerRadius: cornerRadius).addClip();
//        image.draw(in: frame);
//        let im = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return im!;
//    }
    
    /**
     生成二维码
     - parameter urlString:    电话号码
     - parameter surperView:   image View
     - parameter logo:         logo的位置
     - parameter logoSize:     logo的大小
     - parameter cornerRadius: 边角裁剪度
     - returns: 二维码
     */
//    class func GenerateQRCode(urlString:String, surperView:UIView, logo:UIImage, logoSize:CGSize, cornerRadius: CGFloat) -> QRCodeView
//    {
//        let qrCodeView = QRCodeView();
//        
//        qrCodeView.frame = CGRect(x: 0, y: 0, width: surperView.frame.size.width, height: surperView.frame.size.height);
//        //// 该参数代表二维码不可改变
//        let filter = CIFilter.init(name: "CIQRCodeGenerator");
//        filter?.setDefaults();
//        filter?.setValue(urlString.dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage"); //inputMessage 固定写法，代表输入信息 的意思
//        let ciImage = filter?.outputImage;
//        
//        let QRImage = qrCodeView.SetSize(ciImage!, _width: surperView.frame.width);
//        
//        var cornerRadius_1 = cornerRadius;
//        if (!logo.isEqual(nil))
//        {
//            if (cornerRadius_1 < 0)
//            {
//                cornerRadius_1 = 0;
//            }
//        }
//        qrCodeView.layer.contents = QRImage.CGImage;
//        surperView.addSubview(qrCodeView);
//        
//        return qrCodeView;
//    }
//    
}
