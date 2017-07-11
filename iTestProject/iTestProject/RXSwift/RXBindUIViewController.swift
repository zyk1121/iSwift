//
//  RXBindUIViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/9.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 没有对象引用当前对象 当前对象就能释放
class RXBindUIViewController: UIViewController {

    //属性定义
    lazy var btn1:UIButton = {
        let button = UIButton()
        button.setTitle("按钮1", for: [])
        button.setTitleColor(UIColor.red, for: [])
        button.backgroundColor = UIColor.gray
        self.view.addSubview(button)
        return button
    }()
    lazy var label1:UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        return label
    }()
    
    lazy var label2:UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        return label
    }()
    
    lazy var label3:UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        return label
    }()
    
    lazy var sw:UISwitch = {
        let sw = UISwitch()
        self.view.addSubview(sw)
        return sw
    }()
    
    lazy var segment:UISegmentedControl = {
        let seg = UISegmentedControl(items: ["123","456","789"])
        self.view.addSubview(seg)
        return seg
    }()
    
    lazy var slider:UISlider = {
        let slid = UISlider()
        self.view.addSubview(slid)
        return slid
    }()
    //
    dynamic var label1Text:String = "hello"
    
    
    
    var label2Test = Variable<String>("abc")
    
    // label3Text
    var rx_label3Text = Variable<String>("")
    var label3Text : String {
        get {
            return rx_label3Text.value
        }
        
        set {
            rx_label3Text.value = newValue
        }
    }
    
    let disposeBag = DisposeBag()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupData()
        setupUI()
        bindUI()
        updateViewConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    func setupData() {
        
    }
    
    func setupUI() {
        
    }
    
    func bindUI()
    {
        /*
        btn1.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] (event) in
//            self.test_deinit()
            self?.test_deinit()
            print(event)
            // self->btn1->
            // observer->sink->closure->self
            // btn1->controlTarget(addTarget)->block->observer->sink->closure->self->btn1
            // 没有self不会循环引用
        }.addDisposableTo(disposeBag)
 */
        /*
        let dis = btn1.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] (event) in
            //            self.test_deinit()
            self?.test_deinit()
            print(event)
            // self->btn1->
            // observer->sink->closure->self
            // btn1->controlTarget(addTarget)->block->observer->sink->closure->self->btn1
            // 没有self不会循环引用
            }
        dis.dispose()// 点击按钮就不响应了
 */
        btn1.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] (event) in
            //            self.test_deinit()
            self?.test_deinit()
            print(event)
            // self->btn1->
            // observer->sink->closure->self
            // btn1->controlTarget(addTarget)->block->observer->sink->closure->self->btn1
            // 没有self不会循环引用
        }.addDisposableTo(disposeBag)
        
        _ = Observable.just("normal").subscribe(btn1.rx.title(for: .normal))
//        _ = Observable.just("normal").subscribe(button.rx.title(for: .selected))
//        _ = Observable.just("normal").subscribe(button.rx.title())
//        _ = Observable.just(NSAttributedString(string: "normal")).subscribe(button.rx.attributedTitle(for: []))
//        _ = Observable.just(NSAttributedString(string: "normal")).subscribe(button.rx.attributedTitle(for: .selected))
//        _ = Observable.just(image).subscribe(button.rx.image(for: .normal))
//        _ = Observable.just(image).subscribe(button.rx.image(for: .selected))
//        _ = Observable.just(image).subscribe(button.rx.image())
//        _ = Observable.just(image).subscribe(button.rx.backgroundImage(for: .normal))
        
        // button
        
        
        
        // Label（初始化label的值）
        _ = Observable<String>.just("测试Lable字符串").bind(to: label1.rx.text)
        // 利用kvo绑定label的值(有循环引用)
//        _ = self.rx.observe(String.self, "label1Text").bind(to: label1.rx.text)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
//            self.label1Text = "12345678"
//        }
        
        
        // label2
        _ = label2Test.asObservable().bind(to: label2.rx.text)
        label2Test.value = "eeee"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.label2Test.value = "ddddd"
        }
        // label3
        _ = rx_label3Text.asObservable().bind(to: label3.rx.text)
        label3Text = "333"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.label3Text = "uuuuuu"
        }
        
        // switch
        _ = Observable<Bool>.just(true).bind(to: sw.rx.isOn)
        
        // also test two way binding
//        let switchValue = Variable(true)
//        _  = switchValue.asObservable().bind(to: sw.rx.value)
//        switchValue.asObservable().subscribe { (event) in
//            print(event)
//        }
        /*
        _ = sw.rx.controlEvent(UIControlEvents.valueChanged).subscribe {[weak self] (event) in
            print(event)
            print(self?.sw.isOn)
        }
 */
        sw.rx.isOn.asObservable().subscribe {[weak self] (event) in
            self?.test_deinit()
            print(event)
        }.addDisposableTo(disposeBag)
        
        // segment
        _ = Observable<Int>.just(1).bind(to: segment.rx.value)
        segment.rx.selectedSegmentIndex.asObservable().subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
        
        // slider
        _ = Observable<Float>.just(0.6).bind(to: slider.rx.value)
        slider.rx.value .asObservable().subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
        
    }
    
    func test_deinit() {
        print(#function)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        btn1.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view).offset(64)
            make.left.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        label1.snp.remakeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(300)
        }
        label2.snp.remakeConstraints { (make) in
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(300)
        }
        label3.snp.remakeConstraints { (make) in
            make.top.equalTo(label2.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(300)
        }
        
        sw.snp.remakeConstraints { (make) in
            make.top.equalTo(label3.snp.bottom).offset(10)
            make.left.equalTo(self.view)
        }
        
        segment.snp.remakeConstraints { (make) in
            make.top.equalTo(sw.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        slider.snp.remakeConstraints { (make) in
            make.top.equalTo(segment.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(10)
        }
    }

    deinit {
        print(self)
    }
}


/*
 override func viewDidLoad() {
 super.viewDidLoad()
 
 datePicker.date = Date(timeIntervalSince1970: 0)
 
 // MARK: UIBarButtonItem
 
 bbitem.rx.tap
 .subscribe(onNext: { [weak self] x in
 self?.debug("UIBarButtonItem Tapped")
 })
 .disposed(by: disposeBag)
 
 // MARK: UISegmentedControl
 
 // also test two way binding
 let segmentedValue = Variable(0)
 _ = segmentedControl.rx.value <-> segmentedValue
 
 segmentedValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UISegmentedControl value \(x)")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UISwitch
 
 // also test two way binding
 let switchValue = Variable(true)
 _ = switcher.rx.value <-> switchValue
 
 switchValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UISwitch value \(x)")
 })
 .disposed(by: disposeBag)
 
 // MARK: UIActivityIndicatorView
 
 switcher.rx.value
 .bind(to: activityIndicator.rx.isAnimating)
 .disposed(by: disposeBag)
 
 // MARK: UIButton
 
 button.rx.tap
 .subscribe(onNext: { [weak self] x in
 self?.debug("UIButton Tapped")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UISlider
 
 // also test two way binding
 let sliderValue = Variable<Float>(1.0)
 _ = slider.rx.value <-> sliderValue
 
 sliderValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UISlider value \(x)")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UIDatePicker
 
 // also test two way binding
 let dateValue = Variable(Date(timeIntervalSince1970: 0))
 _ = datePicker.rx.date <-> dateValue
 
 
 dateValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UIDatePicker date \(x)")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UITextField
 
 // also test two way binding
 let textValue = Variable("")
 _ = textField.rx.textInput <-> textValue
 
 textValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UITextField text \(x)")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UIGestureRecognizer
 
 mypan.rx.event
 .subscribe(onNext: { [weak self] x in
 self?.debug("UIGestureRecognizer event \(x.state)")
 })
 .disposed(by: disposeBag)
 
 
 // MARK: UITextView
 
 // also test two way binding
 let textViewValue = Variable("")
 _ = textView.rx.textInput <-> textViewValue
 
 textViewValue.asObservable()
 .subscribe(onNext: { [weak self] x in
 self?.debug("UITextView text \(x)")
 })
 .disposed(by: disposeBag)
 
 // MARK: CLLocationManager
 
 #if !RX_NO_MODULE
 manager.requestWhenInUseAuthorization()
 #endif
 
 manager.rx.didUpdateLocations
 .subscribe(onNext: { x in
 print("rx.didUpdateLocations \(x)")
 })
 .disposed(by: disposeBag)
 
 _ = manager.rx.didFailWithError
 .subscribe(onNext: { x in
 print("rx.didFailWithError \(x)")
 })
 
 manager.rx.didChangeAuthorizationStatus
 .subscribe(onNext: { status in
 print("Authorization status \(status)")
 })
 .disposed(by: disposeBag)
 
 manager.startUpdatingLocation()
 
 
 
 }
 */
