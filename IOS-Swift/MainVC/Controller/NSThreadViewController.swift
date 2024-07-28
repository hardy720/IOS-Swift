//
//  NSThreadViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/28.
//

import UIKit

class NSThreadViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray =
        [
            "一、NSThread 的基本概念",
            "二、NSThread 的创建和启动",
            "三、NSThread 的常用操作"
        ]
        dataArray =
        [
            [
                "Swift 中的 NSThread 是苹果提供的一个用于多线程编程的类，它是对 POSIX 线程（pthread）的一个封装，为 Cocoa 开发者提供了在应用中创建和管理线程的能力。",
                "NSThread 对象：每个 NSThread 对象都代表了一个线程。通过创建 NSThread 对象并启动它，你可以在应用中创建新的线程来执行并发任务。",
                "线程的生命周期：NSThread 的生命周期包括创建、就绪、运行、阻塞和死亡五个状态。开发者主要关注的是创建和启动线程，而线程的调度和运行则由系统来管理。"
            ],
            [
                "手动创建并启动",
                "使用类方法创建并自动启动:这种方法会创建一个新线程，并自动启动它，无需手动调用 start() 方法。但请注意，这种方法没有返回值，因此无法直接获取新创建的 NSThread 对象。",
                "使用performSelectorInBackground"
            ],
            [
                "暂停线程(NSThread 没有直接提供暂停线程的方法。但你可以使用 sleepForTimeInterval 或 sleepUntilDate 来让当前线程休眠一段时间。请注意，这会阻塞当前线程，而不是暂停它。)",
                "取消线程（NSThread 的 cancel 方法不会立即停止线程的执行，而是将线程标记为已取消。开发者需要在线程的执行逻辑中检查 isCancelled 属性，并根据需要停止执行。）",
                "获取当前线程和主线程",
                "设置线程优先级（在 iOS 8 及更高版本中，推荐使用 qualityOfService 属性来设置线程的优先级）"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "NSThread"
        view.addSubview(tableView)
        self.view.addSubview(label)
    }
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect.init(x: screenW()/2 - 100, y: 100, width: 200, height: 50))
        label.text = "我是测试UI"
        label.backgroundColor = .green
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
}

// MARK: - 二、NSThread的创建和启动
extension NSThreadViewController
{
    // MARK:2.0.201. 手动创建并启动
    @objc func test201()
    {
        // target 是要执行的方法所属的对象，selector 是要执行的方法名（需要使用 #selector 语法），object 是传递给方法的参数（可以为 nil）。
        let thread = Thread(target: self, selector: #selector(doSomething), object: nil)
        thread.name = "MyThread"
        thread.start()
    }
    
    @objc func doSomething()
    {
        FLPrint("当前线程\(Thread.current)")
        for i in 0...10 {
            Thread.sleep(forTimeInterval: 1)
            FLPrint("执行任务\(i)")
        }
    }
    
    // MARK:2.0.202. 手动创建并启动
    @objc func test202()
    {
        Thread.detachNewThreadSelector(#selector(doSomething), toTarget: self, with: nil)
    }
    
    // MARK:2.0.203. 使用 performSelectorInBackground
    @objc func test203()
    {
        self.performSelector(inBackground: #selector(doSomething), with: nil)
    }
}

// MARK: - 三、NSThread 的常用操作
extension NSThreadViewController
{
    // MARK:3.0.301. 暂停线程
    @objc func test301()
    {
        FLPrint("主线程暂停3秒")
        Thread.sleep(forTimeInterval: 3.0)
    }
    
    // MARK:3.0.302. 取消线程
    @objc func test302()
    {
        let thread = Thread(target: self, selector: #selector(doSomething1), object: nil)
        thread.name = "MyThread"
        thread.start()
    }
    
    @objc func doSomething1()
    {
        for i in 0...20 {
            let currentThread = Thread.current
            Thread.sleep(forTimeInterval: 1);
            FLPrint("线程任务\(i)")
            if i == 10 {
                currentThread.cancel()
            }
            if currentThread.isCancelled {
                return
            }
        }
    }
    
    // MARK:3.0.303. 获取当前线程和主线程
    @objc func test303()
    {
        let currentThread = Thread.current // 获取当前线程
        let mainThread = Thread.main // 获取主线程
        FLPrint("当前线程为\(currentThread),主线程为\(mainThread)")
    }
}
