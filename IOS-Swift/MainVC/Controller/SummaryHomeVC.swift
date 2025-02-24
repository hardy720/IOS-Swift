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
        headDataArray = ["一、语言基础","二、多线程","三、开发模式"]
        dataArray = [
            ["引用类型和值类型","泛型","关键字","异常处理","Optional vs OC 的 nil（强制解包/可选链的安全哲学）详解"],
            ["Grand Central Dispatch(GCD)","NSThread","Operation Queues","并发编程模式(如Actor模式)"],
            ["单例模式"]
        ]
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
    
    // MARK: 1.03.关键字
    @objc func test103()
    {
        self.navigationController?.pushViewController(KeyWordViewController.init(), animated: true)
    }
    
    // MARK: 1.04.异常处理
    @objc func test104()
    {
        self.navigationController?.pushViewController(ExceptionViewController.init(), animated: true)
    }
    
    // MARK: Optional vs OC nil（强制解包/可选链的安全哲学）详解
    @objc func test105()
    {
        self.navigationController?.pushViewController(OptionalVSNilVC.init(), animated: true)
    }
    
    // MARK: 2.01. GCD.
    @objc func test201()
    {
        self.navigationController?.pushViewController(GCDViewController.init(), animated: true)
    }
    
    // MARK: 2.02. NSThread.
    @objc func test202()
    {
        self.navigationController?.pushViewController(NSThreadViewController.init(), animated: true)
    }
    
    // MARK: 2.03.  Operation Queues.
    @objc func test203()
    {
        self.navigationController?.pushViewController(OperationQueuesVC.init(), animated: true)
    }
    
    // MARK: 3.01.  单例开发模式
    @objc func test301()
    {
        self.navigationController?.pushViewController(SingletonViewController.init(), animated: true)
    }
}

