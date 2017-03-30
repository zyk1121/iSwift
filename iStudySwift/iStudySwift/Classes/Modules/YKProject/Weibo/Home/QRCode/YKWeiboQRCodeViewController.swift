//
//  YKWeiboQRCodeViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/28.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKQRCodeURLString = "yk://istudydemo/weibo/home/qrcode"

class YKQRCodeViewController: UIViewController,UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKQRCodeURLString)!) {
                let viewController = YKQRCodeViewController()
                let naviVC = UINavigationController(rootViewController: viewController)
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(naviVC, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKQRCodeURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        scanQRcode()
        
        
        view.setNeedsUpdateConstraints()
    }
    
    /// MARK:loadView
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
    }
    
    deinit {
        print("必须执行代码deinit才会调用！")
    }
    
    /// MARK:返回
    override func goBack() {
        // todo
        super.goBack()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.goBack()
//    }
    
    // MARK:- 自定义view & 布局
    func setupUI() {
        /*let item=UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
         self.navigationItem.rightBarButtonItem=item
         
         let item1=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: nil)//此处使用的图标UIBarButtonSystemItem是一个枚举.大家可以尝试一下其他值出来是什么
         self.navigationItem.rightBarButtonItem=item1
         
         
         let btn1=UIButton(frame: CGRectMake(0, 0, 50, 30))
         btn1.setTitle("完成", forState: UIControlState.Normal)
         let item2=UIBarButtonItem(customView: btn1)
         self.navigationItem.rightBarButtonItem=item2
         
         var img=UIImage(named: "test_img")
         
         let item3=UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
         self.navigationItem.rightBarButtonItem=item3
         
         
         let items1=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: nil)
         let items2=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: nil)
         self.navigationItem.rightBarButtonItems=[items1,items2]
         
         
         // 设置导航栏的背景颜色
         self.navigationController.navigationBar.barTintColor = UIColor.redColor()
         
         // 设置导航栏标题的字体颜色(1)
         self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont("字体名", ofSize: 15)]
         
         // 设置导航栏标题的字体颜色(2)
         设置navigationItem的titleView 通过view中的label属性去改变字体和颜色  self.navigationItem.titleView
         
         // 设置导航栏的按钮图标等的颜色(ToolBar)
         self.navigationController.navigationBar.tintColor = UIColor.orangeColor()
         
         
         //修改导航栏背景色
         self.navigationController?.navigationBar.barTintColor =
         UIColor(red: 55/255, green: 186/255, blue: 89/255, alpha: 1)
         
         self.navigationController?.navigationBar
         .setBackgroundImage(UIImage(named: "bg5"), for: .default)
         */
        
    
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(leftBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(rightBarButtonClick))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftBarButtonClick))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightBarButtonClick))
        
//        testBtn = UIButton()
//        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
//        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
//        testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(testBtn!)
        
        // 添加tabbar
        /*
         
         //添加Tab Bar控件
         var tabBar:UITabBar!
         //Tab Bar Item的名称数组
         var tabs = ["公开课","全栈课","设置"]
         //Tab Bar上方的容器
         var contentView:UIView!
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //在底部创建Tab Bar
         tabBar = UITabBar(frame:CGRect(x:0, y:self.view.bounds.height - 50,
         width:self.view.bounds.width, height:50))
         var items:[UITabBarItem] = []
         for tab in self.tabs {
         let tabItem = UITabBarItem()
         tabItem.title = tab
         items.append(tabItem)
         }
         //设置Tab Bar的标签页
         tabBar.setItems(items, animated: true)
         //本类实现UITabBarDelegate代理，切换标签页时能响应事件
         tabBar.delegate = self
         //代码添加到界面上来
         self.view.addSubview(tabBar);
         
         //上方的容器
         contentView = UIView(frame: CGRect(x:0, y:0, width:self.view.bounds.width,
         height:self.view.bounds.height-50))
         self.view.addSubview(contentView)
         let lbl = UILabel(frame:CGRect(x:100, y:200, width:100, height:20))
         //定义tag，在用户切换tab时能查询到label控件
         lbl.tag = 1
         contentView.addSubview(lbl)
         }
         
         // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
         func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
         (contentView.viewWithTag(1) as! UILabel).text = item.title
         }
         
         */
        view.addSubview(tabBar)
        view.addSubview(qrCodeView)
    }
    
    
    // 
    lazy var qrCodeView : YKQRCodeView = {
        let view = YKQRCodeView(frame:CGRect(x: 0, y: 0, width: 200, height: 200))
        view.center = CGPoint(x: UIScreen.main.bounds.width / 2, y : UIScreen.main.bounds.height/2)
        return view
    }()
    
    // tabbar
    lazy var tabBar : UITabBar = {
        let tabbar = UITabBar()
        tabbar.barTintColor = UIColor.black
        var items:[UITabBarItem] = []
        var imageNames:[String] = ["qrcode_tabbar_icon_qrcode","qrcode_tabbar_icon_barcode"]
        var titles:[String] = ["二维码","条形码"]
        
        for index in 0...1
        {
            let tabItem = UITabBarItem(title: titles[index], image: UIImage(named: imageNames[index]), selectedImage: UIImage(named: imageNames[index]+"_highlighted"))
            items.append(tabItem)
        }
        //设置Tab Bar的标签页
        tabbar.setItems(items, animated: true)
        tabbar.selectedItem = items[0]
        //本类实现UITabBarDelegate代理，切换标签页时能响应事件
        tabbar.delegate = self
        return tabbar
    }()
    
    // MARK:-- tabBar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(#function)
        if item === self.tabBar.items?[0]  {
//            print("===")
            qrCodeView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            qrCodeView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y : UIScreen.main.bounds.height/2)
            qrCodeView.scanLineIcon.image = UIImage(named: "qrcode_scanline_qrcode")
        } else {
            qrCodeView.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
            qrCodeView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y : UIScreen.main.bounds.height/2)
            qrCodeView.scanLineIcon.image = UIImage(named: "qrcode_scanline_barcode")
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     qrCodeView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y : UIScreen.main.bounds.height/2)
    }
    
    override func updateViewConstraints() {
        
//        testBtn?.snp_remakeConstraints(closure: { (maker) in
//            _ = maker.center.equalTo(view)
//        })
        
        tabBar.snp_updateConstraints { (make) in
            _ = make.bottom.equalTo(view)
            _ = make.left.right.equalTo(view)
            _ = make.height.equalTo(49)
        }
        
//        qrCodeView.snp_updateConstraints { (make) in
//            _ = make.center.equalTo(view)
//            _ = make.width.height.equalTo(200)
//        }
        
        // Call [super updateViewConstraints] as the final step in your implementation.
        super.updateViewConstraints()
    }
    
    // MARK: - event
    func testBtnClicked()
    {
        print(#function)
        // testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked), for: UIControlEvents.touchUpInside)
//        print("testBtnClicked")
    }
    
    func testBtnClicked(sender:UIButton) {
        print(#function)
//        print("testBtnClicked(sender:)")
    }
    
    func leftBarButtonClick() {
        //        print(#function)
        goBack()
    }
    
    func rightBarButtonClick()
    {
        print(#function)
        print("相册")
    }
    
    
    // 
    var session : AVCaptureSession?
    var layer: AVCaptureVideoPreviewLayer?;
    
    func scanQRcode()
    {
        self.session = AVCaptureSession();
        
        ////
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo);
        do
        {
            let input = try AVCaptureDeviceInput(device: device);
            
            if (self.session!.canAddInput(input))
            {
                self.session!.addInput(input);
            }
            
            ////输出
            let output = AVCaptureMetadataOutput();

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
            
            if (self.session!.canAddOutput(output))
            {
                self.session!.addOutput(output)
                output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
            }
            
            ////添加图层
            self.layer = AVCaptureVideoPreviewLayer(session:self.session!);
            self.layer?.frame = self.view.frame;
            self.view.layer.insertSublayer(self.layer!, at: 0);
            
            //// 开始扫描
            self.session?.startRunning();
        }
        catch let error as NSError
        {
            print(error);
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        let stringValue:String?;
        
        if (metadataObjects.count > 0)
        {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject;
            
            ////
            stringValue = metadataObject.stringValue;
            if (nil != stringValue) ////这里捕捉到二维码
            {
                self.session!.stopRunning();
                //// 移除图层
                self.layer!.removeFromSuperlayer();
                
                ////启动拨号～～
                print("\(stringValue)")
                goBack()
//                UIApplication.shared.openURL(NSURL(string: "tel://\(stringValue)")! as URL);
                
                
                //                let alertView = UIAlertController(title: "二维码", message: stringValue, preferredStyle: .Alert);
                //                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                //                alertView.addAction(action);
                
                ////显示提示框
                //                self.presentViewController(alertView, animated: true, completion:nil);
            }
            else
            {
                let alertView = UIAlertController(title: "二维码", message: "没有扫描到二维码", preferredStyle: .alert);
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
                alertView.addAction(action);
                
                ////显示提示框
                self.present(alertView, animated: true, completion:nil);
            }
        }
    }
}
