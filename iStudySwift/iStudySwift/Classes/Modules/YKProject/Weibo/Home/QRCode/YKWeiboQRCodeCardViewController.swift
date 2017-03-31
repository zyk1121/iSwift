//
//  YKWeiboQRCodeCardViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/31.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKQRCodeCardURLString = "yk://istudydemo/weibo/home/qrcodecard"

class YKQRCodeCardViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKQRCodeCardURLString)!) {
                let viewController = YKQRCodeCardViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKQRCodeCardURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    
    // MARK: - viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        view.setNeedsUpdateConstraints()
//    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
    }
    
    deinit {
        print("必须执行代码deinit才会调用！")
    }
    
    /// MARK:返回
    override func goBack() {
        // todo
         self.navigationController?.navigationBar.barTintColor = UIColor.black
        super.goBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.goBack()
    }
    
    // MARK:- 自定义view & 布局
    func setupUI() {
//        testBtn = UIButton()
//        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
//        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
//        testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(testBtn!)
    }
    override func updateViewConstraints() {
        
        iconView.snp_remakeConstraints(closure: { (maker) in
            _ = maker.center.equalTo(view)
            _ = maker.width.height.equalTo(200)
        })
        // Call [super updateViewConstraints] as the final step in your implementation.
        super.updateViewConstraints()
    }
    
    // MARK: - event
    func testBtnClicked()
    {
        // testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked), for: UIControlEvents.touchUpInside)
        print("testBtnClicked")
    }
    
    func testBtnClicked(sender:UIButton) {
        print("testBtnClicked(sender:)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置标题
        navigationItem.title = "我的名片"
        view.backgroundColor = UIColor.lightGray
        
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(leftBarButtonClick))
        
        // 2.添加图片容器
        view.addSubview(iconView)
        
        // 3.布局图片容器
        iconView.backgroundColor = UIColor.red
        
        // 4.生成二维码
        let qrcodeImage = creatQRCodeImage()
        
        // 5.将生成好的二维码添加到图片容器上
        iconView.image = qrcodeImage
        
         view.setNeedsUpdateConstraints()
    }

    func leftBarButtonClick() {
        //        print(#function)
        goBack()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    private func creatQRCodeImage() -> UIImage{
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据
        filter?.setValue("hello".data(using: String.Encoding.utf8), forKey: "inputMessage")
        
        // 4.从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        //        return UIImage(CIImage: ciImage!)
        let bgImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: 300)
        
        // 5.创建一个头像
        let icon = UIImage(named: "avatar_vgirl@3x")
        
        // 6.合成图片(将二维码和头像进行合并)
        let newImage = creteImage(bgImage: bgImage, iconImage: icon!)
        
        // 7.返回生成好的二维码
        return newImage
    }
    
    /**
     合成图片
     
     :param: bgImage   背景图片
     :param: iconImage 头像
     */
    private func creteImage(bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint(x:0,y:0), size: bgImage.size))
        // 3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage!
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent)
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    // MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
}
