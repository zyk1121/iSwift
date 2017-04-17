//
//  YKVideoPlayerViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 2017/4/17.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import Foundation

// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKVideoPlayerURLString = "yk://istudydemo/media/video/videoplayer"

class YKVideoPlayerViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKVideoPlayerURLString)!) {
                let viewController = YKVideoPlayerViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKVideoPlayerURLString)!)
    }
    
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    var filePath:String? {
        didSet {
//            print(filePath!)
            self.view.layer.addSublayer(self.playerLayer!)
            self.playerLayer?.player?.play()
        }
    }
    
    lazy var slideBar = { () -> UISlider in
        let slider=UISlider()
        slider.minimumValue=0  //最小值
        slider.maximumValue=1  //最大值
        slider.value=0  //当前默认值
        slider.addTarget(self,action:#selector(YKVideoPlayerViewController.sliderDidchange(sender:)), for:UIControlEvents.valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    
    func sliderDidchange(sender:UISlider)
    {
//        print(sender.value)
        /*
         CMTimeMake和CMTimeMakeWithSeconds 详解
         CMTimeMake(a,b)    a当前第几帧, b每秒钟多少帧.当前播放时间a/b
         
         CMTimeMakeWithSeconds(a,b)    a当前时间,b每秒钟多少帧.
         
         CMTimeMake
         
         CMTime CMTimeMake (
         int64_t value,
         int32_t timescale
         );
         CMTimeMake顧名思義就是用來建立CMTime用的,
         但是千萬別誤會他是拿來用在一般時間用的,
         CMTime可是專門用來表示影片時間用的類別,
         他的用法為: CMTimeMake(time, timeScale)
         
         time指的就是時間(不是秒),
         而時間要換算成秒就要看第二個參數timeScale了.
         timeScale指的是1秒需要由幾個frame構成(可以視為fps),
         因此真正要表達的時間就會是 time / timeScale 才會是秒.
         
         簡單的舉個例子
         
         CMTimeMake(60, 30);
         CMTimeMake(30, 15);
         在這兩個例子中所表達在影片中的時間都皆為2秒鐘,
         但是影隔播放速率則不同, 相差了有兩倍.
         */
        self.playerLayer?.player?.seek(to: CMTimeMake(0, 30));
        self.playerLayer?.player?.play();
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.playerLayer?.frame = self.view.bounds
        self.slideBar.snp_updateConstraints { (make) in
            _ = make.left.equalTo(self.view).offset(20)
            _ = make.right.equalTo(self.view).offset(-20)
            _ = make.bottom.equalTo(self.view).offset(-50)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.playerLayer != nil {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer?.player = nil
            self.playerLayer = nil
        }
    }
    
    lazy var playerLayer:AVPlayerLayer? = {
        let url = NSURL(fileURLWithPath: self.filePath!)
        let item = AVPlayerItem(url: url as URL)
        let player = AVPlayer(playerItem: item)
        let status = player.status
        //初始化播放
        //获取播放器的layer
        let _playerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        //设置播放器的layer
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;// AVLayerVideoGravityResizeAspectFill AVLayerVideoGravityResizeAspect
        _playerLayer.backgroundColor = UIColor.black.cgColor
        _playerLayer.frame = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT);

//        _playerLayer.player?.play()
        return _playerLayer;
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(filePath!)
        view.backgroundColor = UIColor.white
//        setupUI()
        view.setNeedsUpdateConstraints()
    }
    
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
        super.goBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.goBack()
        let pt = touches.first?.location(in: self.view)
        if ((pt?.x)! < CGFloat(40.0) && (pt?.y)! < CGFloat(40.0)) {
            self.goBack()
        }
        self.slideBar.isHidden = !self.slideBar.isHidden
    }
    
    // MARK:- 自定义view & 布局
    func setupUI() {
        testBtn = UIButton()
        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
        testBtn?.addTarget(self, action: #selector(YKVideoPlayerViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(testBtn!)
    }
    override func updateViewConstraints() {
        
//        testBtn?.snp_remakeConstraints(closure: { (maker) in
//            _ = maker.center.equalTo(view)
//        })
        
        // Call [super updateViewConstraints] as the final step in your implementation.
        super.updateViewConstraints()
    }
    
    // MARK: - event
    func testBtnClicked()
    {
        //        print("testBtnClicked")
        print(#function)
        
    }
    
    func testBtnClicked(sender:UIButton) {
        print(#function)
    }
}
