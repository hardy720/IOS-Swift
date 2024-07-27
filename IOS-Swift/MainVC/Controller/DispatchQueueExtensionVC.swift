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

// MARK: - 一、DispatchQueue 基本的扩展
extension DispatchQueueExtensionVC 
{
    // MARK: 1.01、函数只被执行一次
    @objc func test101() {
        DispatchQueue.fl.once(token: "执行一次") {
            FLPrint("执行一次-----")
        }
    }
}

// MARK: - 二、延迟事件
extension DispatchQueueExtensionVC
{
    // MARK: 2.01、异步做一些任务
    @objc func test201() {
        FLAsyncs.async {
            FLPrint("异步做一些任务", "当前的线程是：\(Thread.current)")
        }
    }
    
    // MARK: 2.02、异步做任务后回到主线程做任务
    @objc func test202() {
        FLAsyncs.async {
            FLPrint("异步做任务后回到主线程做任务：子线程做任务", "当前的线程是：\(Thread.current)")
        } _: {
            FLPrint("异步做任务后回到主线程做任务：回到主线程", "当前的线程是：\(Thread.current)")
        }
    }
    
    // MARK: 2.03、异步延迟(子线程执行任务)
    @objc func test203() {
        FLAsyncs.asyncDelay(2) {
            FLPrint("异步延迟(子线程执行任务)", "当前的线程是：\(Thread.current)")
        }
    }
    
    // MARK: 2.04、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    @objc func test204() {
        FLAsyncs.asyncDelay(2) {
            FLPrint("异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)", "当前的线程是：\(Thread.current)")
        } _: {
            FLPrint("异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)", "当前的线程是：\(Thread.current)")
        }
    }
}
