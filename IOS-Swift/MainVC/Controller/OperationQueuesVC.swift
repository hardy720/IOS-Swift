//
//  OperationQueuesVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/28.
//

import UIKit

class OperationQueuesVC: FLBaseViewController {

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
            "一、基本概念",
            "二、添加任务到 OperationQueue",
            "三、控制 OperationQueue 的行为",
            "四、使用场景",
            "五、总结"
        ]
        dataArray =
        [
            [
                "Operation：\nOperation 是 NSOperation 的一个子类（或直接使用 BlockOperation），代表了一个需要执行的任务。\n开发者可以通过继承 NSOperation 并重写其 main 方法来定义自己的任务逻辑。\n每个 Operation 只能被执行一次，并且一旦被添加到某个 OperationQueue 中，就不能再被添加到其他队列中。",
                "OperationQueue：\nOperationQueue 是一个用于调度和执行 Operation 的队列。\n它可以根据 Operation 的依赖关系、优先级以及队列的并发设置来智能地管理任务的执行。"
            ],
            [
                "使用 BlockOperation：\nBlockOperation 是 NSOperation 的一个便捷子类，允许开发者通过闭包来定义任务。",
                "使用自定义 Operation：\n开发者可以创建自定义的 Operation 子类，并在其 main 方法中实现具体的任务逻辑。",
                "添加依赖：Operation 之间可以建立依赖关系，以确保任务按特定顺序执行。"
            ],
            [
                "并发控制：（通过设置 maxConcurrentOperationCount 属性，可以控制队列中同时执行的任务数量。设置为 -1（默认值）表示没有并发限制，队列将尽可能多地并行执行任务。",
                "暂停和恢复： 通过设置 isSuspended 属性，可以暂停和恢复队列中任务的执行。",
                "取消操作：(可以取消队列中的单个操作或所有操作。)"
            ],
            [
                "Operation Queues 特别适用于需要复杂任务调度、依赖管理或优先级控制的场景。例如，在下载多个文件时，可以使用 Operation Queues 来控制下载的并发数，并确保文件按照特定的顺序被处理。"
            ],
            [
                "Swift 中的 Operation Queues 提供了一种强大而灵活的方式来管理和执行异步任务。通过合理使用 Operation 和 OperationQueue，开发者可以构建出高效、可扩展且易于维护的并发应用程序。"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "Operation Queues"
        view.addSubview(tableView)
    }
}

// MARK: - 二、使用 BlockOperation.
extension OperationQueuesVC
{
    // MARK:2.0.201. 使用 BlockOperation.
    @objc func test201()
    {
        let blockOperation = BlockOperation {
            FLPrint("当前线程\(Thread.current)")
        }
        let queue = OperationQueue()
        queue.addOperation(blockOperation)
    }
    
    // MARK:2.0.202. 使用自定义 Operation:
    @objc func test202()
    {
       let customOperation = CustomOperation()
       let queue = OperationQueue()
       queue.addOperation(customOperation)
    }
    
    // MARK:2.0.203. 添加依赖
    @objc func test203()
    {
        let operationA = BlockOperation {
            FLPrint("当前线程A=\(Thread.current)")
        }
        let operationB = BlockOperation {
            FLPrint("当前线程B=\(Thread.current)")
        }
        operationB.addDependency(operationA)
        let queue = OperationQueue()
        queue.addOperation(operationA)
        queue.addOperation(operationB)
    }
    
    // MARK:2.0.204. 取消操作：
    @objc func test204()
    {
        let operation = BlockOperation {
            print("Executing operation")
        }
        operation.cancel() // 取消操作
        let queue = OperationQueue()
        queue.addOperation(operation) // 但如果操作已添加到队列，可能需要其他机制来确保不会执行
        
        let queue1 = OperationQueue()
        // ... 添加操作到队列 ...
        queue1.cancelAllOperations() // 取消队列中所有操作
    }
}

// MARK: - 三、控制 OperationQueue 的行为
extension OperationQueuesVC
{
    // MARK:3.0.301. 并发控制
    @objc func test301()
    {
        // 创建OperationQueue并设置最大并发数
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2 // 设置最大并发数为2
        // 添加多个任务到队列中
        for i in 1...5 {
            let operation = MyCustomOperation()
            queue.addOperation(operation)
            // 可以通过给operation设置name来更好地在控制台中区分它们
            operation.name = "任务\(i)"
        }
        // 注意：由于我们设置了最大并发数为2，所以虽然添加了5个任务，但同一时间只有2个任务会并行执行。
        // 当其中一个任务完成后，队列会自动开始执行下一个等待的任务，直到所有任务都执行完毕。
    }
    
    // MARK:3.0.302. 暂停和恢复：
    @objc func test302()
    {
        // 创建OperationQueue
        let queue = OperationQueue()
          
        // 添加多个任务到队列中
        for i in 1...5 {
            let operation = MyCustomOperation()
            operation.name = "任务\(i)"
            queue.addOperation(operation)
        }
          
        // 暂停队列
        print("暂停队列...")
        queue.isSuspended = true
        // 模拟等待一段时间（这里用sleep来模拟，实际开发中可能是等待用户操作或其他条件）
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("5秒后恢复队列...")
            // 恢复队列
            queue.isSuspended = false
            // 注意：如果队列中的所有操作都已经在暂停之前完成了，恢复队列将不会有任何效果。
            // 在这个示例中，由于我们暂停了队列并且模拟了较长时间的等待，所以一些操作可能在恢复时仍然处于等待状态。
        }
        // 注意：由于OperationQueue是异步的，并且我们使用了Thread.sleep来模拟耗时任务，
        // 所以你可能需要在控制台中观察输出来了解任务的执行顺序和状态。
    }
}

// MARK:2.0.202. 使用自定义 Operation:
class CustomOperation: Operation {
    override func main() {
        FLPrint("当前线程\(Thread.current)")
    }
}



// 3.0.301. 并发控制
class MyCustomOperation: Operation {
  override func main() {
      // 模拟耗时任务
      FLPrint("任务开始执行：\(self)")
      Thread.sleep(forTimeInterval: 3) // 假设这个任务需要2秒完成
      FLPrint("任务执行完成：\(self)")
  }
}

// MARK:3.0.302. 暂停和恢复：
class MyCustomOperation1: Operation
{
    override func main() 
    {
        // 模拟耗时任务
        print("\(self.name ?? "未知任务") 开始执行")
        Thread.sleep(forTimeInterval: 2) // 假设这个任务需要2秒完成
        print("\(self.name ?? "未知任务") 执行完成")
    }
}
