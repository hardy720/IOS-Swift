//
//  GCDViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/20.
//

import UIKit

class GCDViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = 
        [
            "一、GCD的概念",
            "二、GCD的创建与使用",
            "三、GCD的高级用法"
        ]
        dataArray =
        [
            [
                "苹果官方：Grand Central Dispatch(GCD) 是异步执行任务的技术之一。一般将应用程序中记述的线程管理用的代码在系统级实现。开发者只需要定义想执行的任务并追加到适当的Dispatch Queue中，GCD就能生成必要的线程并计划执行任务。由于线程管理是作为系统的一部分来实现的，因此可统一管理，也可执行任务，这样就比以前的线程更有效率。\n GCD用非常简洁的记述方法，实现了极为复杂的多线程编程。",
                "优点：\n多核并行运算：GCD 可以利用多核处理器实现并行运算，充分发挥硬件性能。\n自动管理线程生命周期： GCD 能够自动管理线程的创建、调度和销毁，减轻了开发者的负担。\n简化编程： 开发者只需告诉 GCD 想要执行什么任务，而不需要编写繁琐的线程管理代码。",
            ],
            [
                "任务： 就是执行操作的意思，也就是要在线程中执行的那段代码。在GCD中就是放在Block中的内容。\n具体对任务的执行有两种方式：同步执行和异步执行，主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。",
                "同步执行（sync）：     同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列中的任务完成之后才能执行,dispatch_sync，这个函数会把一个block加入到指定的队列中，而且会一直等到执行完blcok，这个函数才返回。因此在block执行完之前，调用dispatch_sync方法的线程是阻塞的。\n只能在当前线程中执行任务，不具备开启新线程的能力。\n避免在主线程上使用sync：如上所述，这会导致UI无响应和潜在的死锁。\n使用串行队列：sync 调用在串行队列上特别有用，因为你可以确保在继续执行之前，队列中的所有任务都已完成。\n理解死锁：当你尝试在同一个线程上对其自己的队列执行 sync 调用时，就会发生死锁。确保 sync 调用是在不同线程上执行的，或者至少不是在该队列的当前执行线程上.",
                "异步执行（async）：异步添加任务到指定的队列中，不会做任何的等待，可以继续执行任务,使用dispatch_async，这个函数也会把一个block加入到指定的队列中，但是和同步执行不同的是，这个函数把block加入队列后不等block的执行就立刻返回了.在新线程中执行任务，具备开启新线程的能力",
                "队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用先进先出的原则，即新任务总是会被插在队尾，而读取任务则总是从队列的头部开始读取，每读一个任务，则从队列中释放一个任务。GCD中有两种队列：",
                "串行队列（Serial Dispatch Queue）：每次只有一个任务被执行，一个任务执行完再执行下一个，一个接着一个执行。",
                "并发队列（Concurrent Dispatch queue）：可以让多个任务并发（同时）执行。",
                "异步执行与并发队列",
                "同步执行与串行队列",
                "同步执行与并发队列（通常不推荐）",                "主队列（Main Dispatch Queue）：默认存在，用于在主线程中执行任务，与UI更新相关的操作必须放在主队列中执行。",
                "全局队列（Global Dispatch Queue）：系统提供的并发队列，有多个优先级。",
            ],
            [
                "延迟执行",
                "暂停与恢复队列：在Swift中，queue.suspend() 和 queue.resume() 方法通常用于操作并发队列（DispatchQueue），特别是当你需要临时停止队列中任务的执行，并在之后恢复它们时。这些方法在需要精细控制任务执行流程的场景中非常有用，比如暂停动画、下载任务或任何需要在特定条件下暂停和恢复的任务。",
                "取消任务:",
                "调度组（DispatchGroup）:Swift中的调度组（DispatchGroup）是Grand Central Dispatch（GCD）框架的一部分，用于管理多个异步任务的执行。DispatchGroup提供了一种机制，允许开发者等待一组异步任务全部完成后再执行后续操作。以下是关于Swift中DispatchGroup的详细解析："
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "Grand Central Dispatch(GCD)"
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

// MARK: - 一、GCD的创建与使用
extension GCDViewController
{
    
}

// MARK: - 二、GCD的创建与使用
extension GCDViewController
{
    // MARK:1.0.202. 同步执行
    @objc func test202()
    {
        // 创建一个串行队列
        let serialQueue = DispatchQueue(label: "com.example.serialQueue")
        // 在全局队列上异步执行，避免在主线程上阻塞
        DispatchQueue.global(qos: .background).async {
            // 模拟一些异步操作
            Thread.sleep(forTimeInterval: 1)
            // 使用sync在串行队列上同步执行
            serialQueue.sync {
                // 这里执行需要同步的任务
                FLPrint("执行任务在串行队列上，同步执行")
                // 假设这里有一些需要同步的操作
            }
            // sync调用完成后，这里的代码才会执行
            FLPrint("sync调用之后")
        }
        // 主线程继续执行，不会被阻塞
        FLPrint("主线程继续执行")
    }
    
    // MARK:1.0.203. 异步执行
    @objc func test203()
    {
        // 创建一个自定义的串行队列
        let serialQueue = DispatchQueue(label: "com.example.serialQueue")
        // 使用async方法异步执行一个任务
        serialQueue.async {
            // 这里执行你的异步任务
            FLPrint("任务在串行队列中异步执行")
            // 模拟耗时操作
            Thread.sleep(forTimeInterval: 2)
            // 异步任务完成
            FLPrint("串行队列中的异步任务完成")
        }
        // 主线程继续执行，不会被上面的异步任务阻塞
        FLPrint("主线程继续执行，不会等待异步任务完成1111")
        
        // 创建一个自定义的并发队列
        let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
        // 使用async方法异步执行多个任务
        for i in 0..<5 {
            concurrentQueue.async {
                // 这里执行你的异步任务
                let taskId = Thread.current.threadDictionary
                FLPrint("任务\(i) 在并发队列中异步执行，线程ID: \(taskId)")
                // 模拟耗时操作
                Thread.sleep(forTimeInterval: 1)
                // 异步任务完成
                FLPrint("并发队列中的任务\(i) 完成")
            }
        }
          
        // 主线程继续执行，不会被上面的异步任务阻塞
        FLPrint("主线程继续执行，不会等待任何并发任务完成2222")
    }
    
    // MARK:1.0.205.串行队列.
    @objc func test205()
    {
        // 创建一个串行队列的标识符
        let serialQueueLabel = "com.example.serialQueue"
        // 使用该标识符创建一个串行队列
        let serialQueue = DispatchQueue(label: serialQueueLabel)
        // 异步地将任务添加到串行队列中
        serialQueue.async {
            // 这是队列中的第一个任务
            FLPrint("任务1开始执行")
            // 模拟耗时操作
            Thread.sleep(forTimeInterval: 2)
            FLPrint("任务1执行完成")
        }
        // 再次异步地将另一个任务添加到同一个串行队列中
        serialQueue.async {
            // 这个任务会在任务1之后执行，因为队列是串行的
            FLPrint("任务2开始执行")
            // 假设这个任务不需要太长时间
            Thread.sleep(forTimeInterval: 1)
            FLPrint("任务2执行完成")
        }
        // 主线程继续执行，不会被上面的异步任务阻塞
        FLPrint("主线程继续执行，不会等待串行队列中的任务完成")
        // 注意：由于串行队列的特性，任务2会在任务1之后执行，即使任务2的代码先被添加到队列中。
    }
    
    // MARK:1.0.206. 并发队列（Concurrent Dispatch queue）
    @objc func test206()
    {
        // 创建一个并发队列的标识符
        let concurrentQueueLabel = "com.example.concurrentQueue"
        // 使用该标识符和.concurrent属性创建一个并发队列
        let concurrentQueue = DispatchQueue(label: concurrentQueueLabel, attributes: .concurrent)
        // 异步地将多个任务添加到并发队列中
        for i in 1...5 {
            concurrentQueue.async {
                // 这里执行并发任务
                FLPrint("任务\(i)开始执行，线程ID:")
                // 模拟耗时操作
                Thread.sleep(forTimeInterval: 1)
                // 并发任务完成
                FLPrint("任务\(i)执行完成")
            }
        }
        // 主线程继续执行，不会被上面的异步任务阻塞
        FLPrint("主线程继续执行，不会等待并发队列中的任务完成")
        // 注意：由于队列是并发的，所以任务的执行顺序和完成顺序是不确定的。
    }
    
    // MARK:1.0.207. 异步执行与并发队列
    @objc func test207()
    {
        FLPrint(Thread.current)
        DispatchQueue.global(qos: .background).async {
            // 异步执行的任务
            FLPrint("任务1在并发队列中执行")
            FLPrint(Thread.current)
            DispatchQueue.global(qos: .background).async {
                // 可以在并发队列中嵌套异步任务
                FLPrint("任务1.1在并发队列中执行")
                FLPrint(Thread.current)
            }
            FLPrint("任务1完成")
        }
          
        DispatchQueue.global(qos: .background).async {
            // 另一个并发任务
            FLPrint("任务2在并发队列中执行")
            FLPrint("任务2完成")
            FLPrint(Thread.current)
        }
    }
    
    // MARK:1.0.208. 同步执行与串行发队列
    @objc func test208()
    {
        FLPrint(Thread.current)
        let serialQueue = DispatchQueue(label: "com.example.serialQueue")
        serialQueue.sync {
            // 同步执行的任务会阻塞当前线程直到完成
            FLPrint("任务1在串行队列中同步执行")
            // 注意：在串行队列的同步块中嵌套同步块可能会导致死锁
            // serialQueue.sync {
            //     FLPrint("这里不应该嵌套同步块")
            // }
            FLPrint(Thread.current)
            FLPrint("任务1完成")
        }
          
        serialQueue.async {
            // 异步执行的任务不会阻塞当前线程
            FLPrint("任务2在串行队列中异步执行")
            FLPrint("任务2完成")
            FLPrint(Thread.current)
        }
    }
    
    // MARK:1.0.209. 同步执行与并发队列
    @objc func test209()
    {
        DispatchQueue.global(qos: .background).sync {
            // 同步执行会阻塞当前队列中的其他任务，直到此任务完成
            FLPrint("任务在并发队列中同步执行，不推荐使用")
            // 这里的操作会阻塞并发队列的其他任务
            // 谨慎使用
            Thread.sleep(forTimeInterval: 2)
            FLPrint("任务完成")
        }
    }
    // MARK: 2.02. 主队列
    @objc func test210()
    {
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            FLPrint("---开始在主线程更新UI--\(mainQueue)")
            self.label.text = "在主线程中更新UI"
        }
    }
    
    // MARK: 2.03. 全局队列
    @objc func test211()
    {
        let globalQueue = DispatchQueue.global(qos: .default)
        globalQueue.async {
            FLPrint("我是全局队列%@",Thread.current)
            DispatchQueue.main.async {
                self.label.text = "在主线程中更新UI"
            }
        }
    }
}

extension GCDViewController
{
    // MARK: 3.01. 延迟执行
    @objc func test301()
    {
        FLPrint("开始执行")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            // 延迟2秒后执行
            FLPrint("开始延时执行")
        }
    }
    
    // MARK: 3.02. 暂停和恢复队列
    @objc func test302()
    {
        // 创建一个自定义的并发队列
        let customConcurrentQueue = DispatchQueue(label: "com.example.customConcurrentQueue", attributes: .concurrent)
        // 模拟一些异步任务
        func performAsyncTask(queue: DispatchQueue, taskId: Int) {
            queue.async {
                let startTime = Date()
                // 模拟耗时操作
                Thread.sleep(forTimeInterval: 2)
                let endTime = Date()
                let elapsedTime = endTime.timeIntervalSince(startTime)
                FLPrint("任务 \(taskId) 完成，耗时 \(elapsedTime) 秒")
            }
        }
        // 向队列中添加任务
        for i in 1...1115 {
            FLPrint("---\(i)")
            performAsyncTask(queue: customConcurrentQueue, taskId: i)
        }
        // 暂停队列
        FLPrint("暂停队列...")
        customConcurrentQueue.suspend()
        // 等待一段时间，以观察暂停效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            // 恢复队列
            FLPrint("恢复队列...")
            customConcurrentQueue.resume()
            // 可以选择再次添加任务或继续执行队列中剩余的任务
            // performAsyncTask(queue: customConcurrentQueue, taskId: 6)
        }
        // 注意：由于队列是并发的，任务的执行顺序和完成时间可能不是线性的。
        // 此外，如果队列在恢复之前就已经完成了所有任务，那么恢复操作将不会有任何效果
    }
    
    // MARK: 3.03. 取消任务
    @objc func test303()
    {
        // 创建一个全局的并发队列
        let queue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
        // 定义一个布尔变量来控制任务是否应该被取消
        var isTaskCancelled = false
        // 创建一个封装了任务的 DispatchWorkItem
        let task = DispatchWorkItem {
            // 在执行任务之前检查是否已取消
            if isTaskCancelled {
                FLPrint("任务已取消，不会执行。")
                return
            }
            // 模拟任务执行
            FLPrint("任务开始执行...")
            // 假设这里有一些耗时的操作
            Thread.sleep(forTimeInterval: 2) // 注意：在实际应用中，避免在主线程中使用 Thread.sleep
            FLPrint("任务执行完毕。")
        }
          
        // 将任务添加到队列中执行
        queue.async(execute: task)
          
        // 假设在某个时刻，我们决定取消任务
        // 注意：这里的取消是模拟的，因为 GCD 并不直接支持取消任务
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 设置取消标志
            isTaskCancelled = true
            FLPrint("尝试取消任务...")
          
            // 注意：即使设置了取消标志，如果任务已经开始执行并且没有检查 isTaskCancelled，它仍然会继续执行
            // 这就是为什么我们说这是“模拟”取消
        }
          
        // 输出结果将取决于任务开始执行和取消请求之间的时间差
        // 如果取消请求在任务开始执行之前到达，则任务将不会执行
        // 如果取消请求在任务开始执行之后到达，但任务内部检查了 isTaskCancelled 并据此决定停止执行，则任务将不会完成其所有操作
    }
    
    // MARK: 3.03. 调度组（DispatchGroup）
    @objc func test304()
    {
        let group = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1")
        queue1.async(group: group) {
            Thread.sleep(forTimeInterval: 1)
            FLPrint("任务一完成")
        }
        let queue2 = DispatchQueue(label: "queue2")
        queue2.async(group: group) {
            Thread.sleep(forTimeInterval: 3)
            let date = Date()
            FLPrint("任务二完成")
        }
        let queue3 = DispatchQueue(label: "queue3")
        queue3.async(group: group){
            Thread.sleep(forTimeInterval: 1)
            FLPrint("任务三完成")
        }
        group.wait()
        //等待group的任务都执行完成后向下执行
        FLPrint("我是最后一行代码")
    }
}
