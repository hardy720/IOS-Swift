//
//  DispatchQueueExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/14.
//

import UIKit

class DispatchQueueExtensionVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、DispatchQueue 基本的扩展", "二、延迟事件"]
        dataArray = [["函数只被执行一次"], ["异步做一些任务", "异步做任务后回到主线程做任务" , "异步延迟(子线程执行任务)", "异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)"]]
    }
    
    func initUI()
    {
        self.title = "DispatchQueue+Extension"
        view.addSubview(tableView)
    }
}
