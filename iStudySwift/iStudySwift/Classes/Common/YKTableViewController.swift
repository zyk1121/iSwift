//
//  YKTableViewController.swift
//  iStudySwift
//
//  Created by zhangyuanke on 17/3/19.
//  Copyright © 2017年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

let kYKSwiftCellDefault = "YKSwiftCellDefault"


class YKTableViewController : UITableViewController
{
    // tableView 数据，二维数组
    var tableviewData:[[Any]] = [["测试1","测试2"],["测试3","测试4"]]
    // section header 默认
    var tableSectionHeaderData:[String] = ["section1","section2"]
    
    override func loadView() {
        super.loadView()
//        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.register(UITableViewCell.self,
                                 forCellReuseIdentifier: kYKSwiftCellDefault)
    }
    
    public override class func initialize()
    {
        super.initialize()
//        print(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// MARK:table delegate datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        /*unable to dequeue a cell with identifier SwiftCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'*/
        let identify:String = kYKSwiftCellDefault
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                 for: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.textLabel?.text = (String)(describing: tableviewData[indexPath.section][indexPath.row])
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        selectRowAt(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableviewData.count == 1 {
            return 0
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= tableSectionHeaderData.count {
            return "默认section"
        }
        return tableSectionHeaderData[section]
    }
    
    /// 选中某一行(可以重写)
    func selectRowAt(indexPath: IndexPath) {
        // 建议重写
    }
}
