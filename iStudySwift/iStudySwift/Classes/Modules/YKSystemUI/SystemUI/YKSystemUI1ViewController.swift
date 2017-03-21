//
//  YKSystemUIViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/21.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKSystemUI1URLString = "yk://istudydemo/systemui/simple1"

class YKSystemUI1ViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKSystemUI1URLString)!) {
                let viewController = YKSystemUI1ViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKSystemUI1URLString)!)
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
        view.backgroundColor = UIColor.white
        setupUI()
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
    }
    
    // MARK: - 属性 & 懒加载
    lazy var btn1:UIButton = {
        let button = UIButton(type: UIButtonType.contactAdd)
        return button
    }()
    lazy var btn2:UIButton = {
        let button = UIButton()
        button.setTitle("测试", for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    /*
     
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
     */
    lazy var btn3:UIButton = {
        let button = UIButton(imageName: "navigationbar_friendattention", backgroundImageName: "")
        return button
    }()
    
    lazy var btn4:UIButton = {
        let button = UIButton()
//        let button = UIButton(frame:CGRect(x:0, y:64, width:130, height:50))
        button.setTitle("这个是一段 very 长的文字", for:.normal) //普通状态下的文字
        button.setTitleColor(UIColor.white, for: .normal) //普通状态下文字的颜色
        button.backgroundColor = UIColor.orange
        //省略尾部文字(文字太长时的处理方法)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button;
    }()
    
    lazy var label1:UILabel = {
        let label = UILabel()
        label.text = "hello world"
        label.textColor = UIColor.white //白色文字
        label.backgroundColor = UIColor.black //黑色背景
        label.textAlignment = .center//文字对齐
        label.shadowColor = UIColor.gray  //灰色阴影
        label.shadowOffset = CGSize(width:1.5, height:1.5)  //阴影的偏移量
//        label.font = UIFont(name:"Zapfino", size:13)
        /*
         6，文字过长时的省略方式
         1
         2
         3
         4
         label.lineBreakMode = .byTruncatingTail  //隐藏尾部并显示省略号
         label.lineBreakMode = .byTruncatingMiddle  //隐藏中间部分并显示省略号
         label.lineBreakMode = .byTruncatingHead  //隐藏头部并显示省略号
         label.lineBreakMode = .byClipping  //截去多余部分也不显示省略号
         
         7，文字大小自适应标签宽度
         1
         label.adjustsFontSizeToFitWidth = true //当文字超出标签宽度时，自动调整文字大小，使其不被截断
         
         8，使标签可以显示多行文字
         1
         label.numberOfLines = 2  //显示两行文字（默认只显示一行，设为0表示没有行数限制）
         
         //设置文本高亮
         label.isHighlighted = true
         //设置文本高亮颜色
         label.highlightedTextColor = UIColor.green
         
         //富文本设置
         let attributeString = NSMutableAttributedString(string:"welcome to hangge.com")
         //从文本0开始6个字符字体HelveticaNeue-Bold,16号
         attributeString.addAttribute(NSFontAttributeName,
         value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
         range: NSMakeRange(0,6))
         //设置字体颜色
         attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue,
         range: NSMakeRange(0, 3))
         //设置文字背景颜色
         attributeString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.green,
         range: NSMakeRange(3,3))
         label.attributedText = attributeString
         */
        return label
    }()
    
    
    lazy var label2:UILabel = {
        let label = UILabel()
        label.text = "hello"
        label.isHighlighted = true
        //设置文本高亮颜色
        label.highlightedTextColor = UIColor.green
        return label
    }()
    
    lazy var line1:UIView = {
        var line = UIView()
        line.backgroundColor = UIColor.init(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        return line
    }()
    
     //富文本设置
    lazy var label3:UILabel = {
        //富文本设置
        let label = UILabel()
        let attributeString = NSMutableAttributedString(string:"welcome to hangge.com")
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0,6))
        //设置字体颜色
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue,
                                     range: NSMakeRange(0, 3))
        //设置文字背景颜色
        attributeString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.green,
                                     range: NSMakeRange(3,3))
        label.attributedText = attributeString
        return label
    }()
    
    
    // MARK:- 自定义view & 布局
    func setupUI() {
//        testBtn = UIButton()
//        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
//        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
//        testBtn?.addTarget(self, action: #selector(YKTestViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(testBtn!)
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(btn4)
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(line1)
        
        view.addSubview(label3)
    }
    override func updateViewConstraints() {
        
//        testBtn?.snp_remakeConstraints(closure: { (maker) in
//            _ = maker.center.equalTo(view)
//        })
        
        btn1.snp_updateConstraints { (make) in
            _ = make.top.equalTo(view).offset(64)
            _ = make.left.equalTo(view)
        }
        
        btn2.snp_updateConstraints { (make) in
            _ = make.top.equalTo(btn1)
            _ = make.left.equalTo(btn1.snp_right)
        }
        
        btn3.snp_updateConstraints { (make) in
            _ = make.top.equalTo(btn2)
            _ = make.left.equalTo(btn2.snp_right)
        }
        
        btn4.snp_updateConstraints { (make) in
            _ = make.top.equalTo(btn3)
            _ = make.left.equalTo(btn3.snp_right)
            _ = make.width.equalTo(120)
            _ = make.height.equalTo(30)
        }
        
        label1.snp_updateConstraints { (make) in
            _ = make.top.equalTo(btn4)
            _ = make.left.equalTo(btn4.snp_right)
        }
        
        label2.snp_updateConstraints { (make) in
            _ = make.top.equalTo(label1)
            _ = make.left.equalTo(label1.snp_right)
        }
        
        line1.snp_updateConstraints { (make) in
            _ = make.top.equalTo(btn4.snp_bottom).offset(3)
            _ = make.left.equalTo(view)
            _ = make.right.equalTo(view)
            _ = make.height.equalTo(0.5)
        }
        
        label3.snp_updateConstraints { (make) in
            _ = make.top.equalTo(line1.snp_bottom).offset(3)
            _ = make.left.equalTo(view)
        }
        
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
}
