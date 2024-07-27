//
//  SummaryHomeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/11.
//

import UIKit

class SummaryHomeVC: FLBaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    func initData() 
    {
        headDataArray = ["一、语言基础","二、多线程"]
        dataArray = [["引用类型和值类型","泛型","Where"],["Grand Central Dispatch(GCD)","Operation Queues","NSThread","并发编程模式(如Actor模式)"]]
    }
    
    func initUI()  
    {
        self.title = "Summary"
        view.addSubview(tableView)
    }
}

// MARK: - 一、语言基础
extension SummaryHomeVC
{
    // MARK: 1.01. 引用类型和值类型
    @objc func test101()
    {
        self.navigationController?.pushViewController(SystemTypeVC.init(), animated: true)
    }
    // MARK: 1.02.
    @objc func test102()
    {
    }
    
    // MARK: 2.01. GCD.
    @objc func test201()
    {
        self.navigationController?.pushViewController(GCDViewController.init(), animated: true)
    }
}
