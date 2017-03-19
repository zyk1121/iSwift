//
//  ViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/14.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var itemKeys = ["01-系统控件",
                    "02-项目",
                    "03-第三方",
                    "04-网络Http",
                    ]
    var items:[String:String] = ["01-系统控件":kYKSystemUIURLString,
                                 "02-项目":kYKProjectURLString,
                                 "03-第三方":kYKThirdPartURLString,
                                 "04-网络Http":kYKNetworkURLString,
                                 
                                 "99-测试":kYKTestTableViewURLString,
                                 ]
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "iSwift"
//        print(self.navigationItem.title ?? "123")
        self.view.backgroundColor = UIColor.white
        // 返回按钮
        let returenButtonItem = UIBarButtonItem()
        returenButtonItem.title = "返回"
        self.navigationItem.backBarButtonItem = returenButtonItem
    }
    
    override func loadView() {
        super.loadView()
        self.setupUI()
        self.view.setNeedsUpdateConstraints()
    }
    
    func setupUI() {
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                      forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(tableView!)
    }
    
    override func updateViewConstraints() {
        self.tableView?.snp_updateConstraints(closure: { (make) in
            _ = make.edges.equalTo(self.view)
        })
        super.updateViewConstraints()
    }
    
    
    /// MARK:table delegate datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        /*unable to dequeue a cell with identifier SwiftCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'*/
        let identify:String = "SwiftCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                 for: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        cell.textLabel?.text = findKeyForRow(row: indexPath.row)
        cell.textLabel?.text = itemKeys[indexPath.row]
        return cell

    }
    
    func findKeyForRow(row:Int) -> String {
        let keys = items.keys
        
        for (index, item) in keys.enumerated() {
            if index == row {
                return item
            }
        }
        return "defaultkey"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        self.selectRow(row: indexPath.row)
    }
    
    /// 选中某一行
    func selectRow(row : Int) {
//        let key = findKeyForRow(row: row)
        let key = itemKeys[row]
        
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: items[key]!)!,transferType: .YKTransferTypePush) { (destViewController : UIViewController?, error:NSError?) in
            
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    /*
    // 测试代码
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: kYKTestURLString)!,transferType: .YKTransferTypePush) { (destViewController : UIViewController?, error:NSError?) in
            
        }
 
        YKPortal.transferFromViewController(sourceViewController: self, toURL: NSURL(string: kYKTestURLString)!,transferType: .YKTransferTypePresent) { (destViewController : UIViewController?, error:NSError?) in
          }
    }
     */
}
