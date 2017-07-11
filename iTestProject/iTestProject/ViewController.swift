//
//  ViewController.swift
//  iTestProject
//
//  Created by 张元科 on 2017/7/1.
//  Copyright © 2017年 SDJG. All rights reserved.
//

import UIKit

import RxSwift

class ViewController: UIViewController {

    var tableViewKeys:[String] = []
    var tableViewData:[String:String] = [:]
    
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupData()
        setupUI()
    }
    
    func setupData() {
        tableViewKeys = ["RxSwift基础","冷热信号","统一监听方法","绑定UI","使用实战"]

        tableViewData = ["RxSwift基础":"sdjg://router/rx/base",
                         "冷热信号":"sdjg://router/rx/coldhot",
                         "统一监听方法":"sdjg://router/rx/observe",
                         "绑定UI":"sdjg://router/rx/bindui",
                         "使用实战":"sdjg://router/rx/use"]
    }
    
    func setupUI()
    {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "test")
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = 70
        tableView?.tableFooterView = UIView()
        view.addSubview(tableView!)
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        cell.textLabel?.text = tableViewKeys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = tableViewKeys[indexPath.row]
        let value = tableViewData[key]
//        SDJGUrlRouterManager.router(sourceVC: self, toURL: NSURL(string:value!)!)
        SDJGUrlRouterManager.router(sourceVC: self, toURL: NSURL(string:value!)!, transferType: .push, userInfo: nil) { (vc, error) in
            vc?.title = key
        }
    }
}






