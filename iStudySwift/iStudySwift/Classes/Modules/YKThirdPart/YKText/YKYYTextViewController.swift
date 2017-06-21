//
//  YKYYTextViewController.swift
//  iStudySwift
//
//  Created by 张元科 on 2017/6/20.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit
import UIKit
import SnapKit
import YYText

// 注意，页面Portal跳转不成功，请在YKPortal方法中注册类的初始化方法
let kYKYYTextURLString = "yk://istudydemo/thirdpart/yytext"

class YKYYTextViewController: UIViewController {
    
    // MARK: - Portal 相关
    static func portalLoad()
    {
        YKPortal.registerPortalWithHandler(handler: { (transferURL:NSURL, transferType:YKTransferType, sourceViewController:UIViewController) -> UIViewController? in
            
            if transferURL.hasSameTrunkWithURL(URL: NSURL(string:kYKYYTextURLString)!) {
                let viewController = YKYYTextViewController()
                if transferType.rawValue == 0 {
                    sourceViewController.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    sourceViewController.present(viewController, animated: true, completion: nil)
                }
                
                return viewController
            } else {
                return nil
            }
        }, prefixURL: NSURL(string: kYKYYTextURLString)!)
    }
    public override class func initialize()
    {
        super.initialize()
        portalLoad()
    }
    
    // MARK: - 属性
    var testBtn:UIButton?
    var label1:YYLabel?
    var label2:YYLabel?
    var label3:YYLabel?
    var label4:YYLabel?
    var label5:YYLabel?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK:- 自定义view & 布局
    func setupUI() {
        testBtn = UIButton()
        testBtn?.setTitle("测试按钮", for: UIControlState.normal)
        testBtn?.setTitleColor(UIColor.red, for: UIControlState.normal)
        testBtn?.addTarget(self, action: #selector(YKYYTextViewController.testBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(testBtn!)
        
        /*
         // YYLabel (similar to UILabel)
         YYLabel *label = [YYLabel new];
         label.frame = ...
         label.font = ...
         label.textColor = ...
         label.textAlignment = ...
         label.lineBreakMode = ...
         label.numberOfLines = ...
         label.text = ...
         
         // YYTextView (similar to UITextView)
         YYTextView *textView = [YYTextView new];
         textView.frame = ...
         textView.font = ...
         textView.textColor = ...
         textView.dataDetectorTypes = ...
         textView.placeHolderText = ...
         textView.placeHolderTextColor = ...
         textView.delegate = ...
         */
        let label1 = YYLabel()
        label1.text = "label1"
        label1.textColor = UIColor.red
        view.addSubview(label1)
        self.label1 = label1
        
        // 1. Create an attributed string.
        let text = NSMutableAttributedString(string: "Some Text, blabla...")
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Some Text, blabla..."];
        
        // 2. Set attributes to text, you can use almost all CoreText attributes.
//        text.yy_font = [UIFont boldSystemFontOfSize:30];
        text.yy_font = UIFont.boldSystemFont(ofSize: 20);
        text.yy_color = UIColor.blue
//        text.yy_color = [UIColor blueColor];
        text.yy_setColor(UIColor.red, range: NSRange(location: 0,length: 4))
//        [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
        text.yy_lineSpacing = 10;
        
        
//        [text yy_setTextHighlightRange:range
//            color:[UIColor blueColor]
//            backgroundColor:[UIColor grayColor]
//            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//            NSLog(@"tap text range:...");
//            }];
        
        text.yy_setTextHighlight(NSRange(location: 0,length: 4), color: UIColor.red, backgroundColor: UIColor.gray) { (containerView, text, range, rect) in
            print(range)
        }
        
        // 3. Set to YYLabel or YYTextView.
        let label2 = YYLabel();
        label2.attributedText = text;
        view.addSubview(label2)
        self.label2 = label2
        
        /*
         
         // 1. Create a 'highlight' attribute for text.
         YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
         
         YYTextHighlight *highlight = [YYTextHighlight new];
         [highlight setColor:[UIColor whiteColor]];
         [highlight setBackgroundBorder:highlightBorder];
         highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
         NSLog(@"tap text range:...");
         // you can also set the action handler to YYLabel or YYTextView.
         };
         
         // 2. Add 'highlight' attribute to a range of text.
         [attributedText yy_setTextHighlight:highlight range:highlightRange];
         
         // 3. Set text to label or text view.
         YYLabel *label = ...
         label.attributedText = attributedText
         
         YYTextView *textView = ...
         textView.attributedText = ...
         
         // 4. Receive user interactive action.
         label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
         NSLog(@"tap text range:...");
         };
         label.highlightLongPressAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
         NSLog(@"long press text range:...");
         };
         
         @UITextViewDelegate
         - (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
         NSLog(@"tap text range:...");
         }
         - (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
         NSLog(@"long press text range:...");
         }
         
         */
        
//        YYTextView *textView = [YYTextView new];
//        textView.frame = ...
//            textView.attributedString = text;
        
        
        
        let text3 = NSMutableAttributedString(string: "attachment")
        let label3 = YYLabel();
        text3.yy_font = UIFont.systemFont(ofSize: 26)
        text3.yy_lineSpacing = 10;
        
        
        
        let image = UIImage(named: "icon")
        var attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: UIViewContentMode.center, attachmentSize: (image?.size)!, alignTo: UIFont.systemFont(ofSize: 26), alignment: YYTextVerticalAlignment.center)
        text3.append(attachment)
        
        let switcher = UISwitch()
        switcher.sizeToFit()
        switcher.addTarget(self, action: #selector(testFunc), for: .touchUpInside)
        attachment = NSMutableAttributedString.yy_attachmentString(withContent: switcher, contentMode: UIViewContentMode.center, attachmentSize: (image?.size)!, alignTo: UIFont.systemFont(ofSize: 26), alignment: YYTextVerticalAlignment.center)
        text3.append(attachment)
        
        
        label3.attributedText = text3;
        
        view.addSubview(label3)
        self.label3 = label3
        
        /*
         NSMutableAttributedString *text = [NSMutableAttributedString new];
         UIFont *font = [UIFont systemFontOfSize:16];
         NSMutableAttributedString *attachment = nil;
         
         // UIImage attachment
         UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
         attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
         [text appendAttributedString: attachment];
         
         // UIView attachment
         UISwitch *switcher = [UISwitch new];
         [switcher sizeToFit];
         attachment = [NSMutableAttributedString yy_attachmentStringWithContent:switcher contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
         [text appendAttributedString: attachment];
         
         // CALayer attachment
         CASharpLayer *layer = [CASharpLayer layer];
         layer.path = ...
         attachment = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
         [text appendAttributedString: attachment];
         
         
         */
      
        
        /*
         
         Text layout calculation
         
         NSAttributedString *text = ...
         CGSize size = CGSizeMake(100, CGFLOAT_MAX);
         YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
         
         // get text bounding
         layout.textBoundingRect; // get bounding rect
         layout.textBoundingSize; // get bounding size
         
         // query text layout
         [layout lineIndexForPoint:CGPointMake(10,10)];
         [layout closestLineIndexForPoint:CGPointMake(10,10)];
         [layout closestPositionToPoint:CGPointMake(10,10)];
         [layout textRangeAtPoint:CGPointMake(10,10)];
         [layout rectForRange:[YYTextRange rangeWithRange:NSMakeRange(10,2)]];
         [layout selectionRectsForRange:[YYTextRange rangeWithRange:NSMakeRange(10,2)]];
         
         // text layout display
         YYLabel *label = [YYLabel new];
         label.size = layout.textBoundingSize;
         label.textLayout = layout;
         
         
         */
        
        let text4 = NSMutableAttributedString(string: "测试字符串长度很长的时候换行以及计算行高问题，测试字符串长度很长的时候换行以及计算行高问题，测试字符串长度很长的时候换行以及计算行高问题，测试字符串长度很长的时候换行以及计算行高问题，测试字符串长度很长的时候换行以及计算行高问题")
        text4.yy_font = UIFont.systemFont(ofSize: 24)
        let label4 = YYLabel()
        label4.attributedText = text4
        
        
        //计算选项内容label的布局
        let container = YYTextContainer()
        
        container.size = CGSize(width:UIScreen.main.bounds.width - 20, height:YYTextContainerMaxSize.height)
        container.maximumNumberOfRows = 0
        let layout = YYTextLayout(container: container, text: text4)
        
        var height = layout!.textBoundingSize.height
        label4.textLayout = layout
        
        //计算高度
        
        height = height > 30 ? height : 30
        
        // 只是更新布局
        label4height = height
        
        
//        label4.snp_updateConstraints(closure: { (make) in
//            make.height.equalTo(height)
//        })
 
        
        
//        label4.font = UIFont.systemFont(ofSize: 24)
        label4.numberOfLines = 0
        label4.displaysAsynchronously = true
        label4.fadeOnHighlight = false
        label4.fadeOnAsynchronouslyDisplay = false
        label4.textVerticalAlignment = YYTextVerticalAlignment.center
        label4.textColor = UIColor.red
        view.addSubview(label4)
        self.label4 = label4
       
        
        
        
        
    }
    
    var label4height:CGFloat = 0
    
    override func updateViewConstraints() {
        
        testBtn?.snp_remakeConstraints(closure: { (maker) in
            _ = maker.center.equalTo(view)
        })
        
        label1?.snp_remakeConstraints(closure: { (make) in
            _ = make.top.equalTo(view).offset(64)
            _ = make.left.equalTo(view)
        })
        
        label2?.snp_remakeConstraints(closure: { (make) in
            _ = make.top.equalTo((label1?.snp_bottom)!)
            _ = make.left.equalTo(view)
        })
        label3?.snp_remakeConstraints(closure: { (make) in
            _ = make.top.equalTo((label2?.snp_bottom)!)
            _ = make.left.equalTo(view)
        })
        
        label4?.snp_remakeConstraints(closure: { (make) in
            _ = make.top.equalTo((label3?.snp_bottom)!)
            _ = make.left.equalTo(view).offset(10)
            _ = make.right.equalTo(view).offset(-10)
            make.height.equalTo(label4height)
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
    
    func testFunc()
    {
        print(#function)
    }

}
