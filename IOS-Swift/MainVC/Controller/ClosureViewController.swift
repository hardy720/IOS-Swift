//
//  ClosureViewController.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/4/22.
//

import UIKit

class ClosureViewController: FLBaseViewController {

    var name = "Demo"
    var onTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = [
            "一、说明",
            "二、闭包的三种形式",
            "三、闭包表达式语法"
        ]
        dataArray = [
            ["闭包是 Swift 中一种自包含的功能代码块，可以在代码中被传递和使用。你可以把它理解为“匿名函数”或“函数字面量”。Swift 中的闭包与 C 和 Objective-C 中的 block 类似，也与其他语言中的 lambda 表达式（如 Python、JavaScript 的箭头函数）相似。闭包能够捕获和存储其所在上下文中的任何常量或变量的引用，这被称为闭包捕获值。即使定义这些常量或变量的原始作用域已经消失，闭包仍然可以修改或使用它们。"],
            ["全局函数:\n有名字但不会捕获任何值（如 func 定义的函数）。实际上是一种特殊的闭包。","嵌套函数:有名字且可以从其外层函数捕获值。","闭包表达式:无名字，使用轻量级语法书写的匿名闭包。通常我们说的“闭包”多指这种。"],
            ["最简单的闭包示例:",
             "没有参数、没有返回值的闭包:闭包最常见的用途是作为参数传递给函数，特别是在异步操作、排序、遍历等高阶函数中。",
             "闭包作为函数参数:",
             "闭包的简写语法:\n (1)类型推断:因为 compute 函数已经声明了 operation 的参数和返回值类型，调用时可以省略闭包的参数类型和返回值类型。",
             "闭包的简写语法:\n (2)单表达式隐式返回:如果闭包体只有一行 return 语句，可以省略 return 关键字。",
             "闭包的简写语法:\n (3)参数名称缩写（$0, $1, ...）:Swift 自动为闭包的参数提供缩写名称：$0 表示第一个参数，$1 第二个，依此类推。此时可以省略参数列表和 in 关键字。",
             "闭包的简写语法:\n 尾随闭包 (Trailing Closure):如果闭包是函数的最后一个参数，可以将闭包写在函数括号外面，增强可读性。如果函数只有一个参数且该参数是闭包，甚至可以省略函数括号：",
             "闭包捕获值:\n闭包可以捕获其定义时所在上下文中的变量和常量，即使这些变量原本的作用域已经结束。原理：闭包内部对 count 的引用会增加其引用计数，所以 count 不会因为 makeCounter 函数执行完毕而销毁，而是随着闭包一起存在。",
             "逃逸闭包 (@escaping):\n当一个闭包作为参数传递给函数，并且在函数返回之后才被调用，那么这个闭包就是逃逸闭包。通常用于异步操作（如网络请求、延时执行）.需要在参数类型前写上 @escaping 关键字。注意：如果不加 @escaping，Swift 默认闭包是非逃逸的，意味着闭包必须在函数结束前同步执行完毕。\n为什么需要 @escaping？\n逃逸闭包中如果使用了 self，必须显式写 self，提醒开发者注意循环引用。\n非逃逸闭包编译器可以做更多优化。",
             "自动闭包 (@autoclosure):\n自动闭包是一种自动创建的闭包，用于包装传递给函数参数的表达式。它不接受任何参数，当被调用时返回包装的表达式的值。使用 @autoclosure 可以省略花括号。\n@autoclosure 常用于断言或短路求值场景，能提高调用方的简洁性。但过度使用可能降低可读性。",
             "循环引用与捕获列表:\n闭包是引用类型。当闭包捕获一个类实例（如 self）且该实例也持有闭包时，可能形成强引用循环（内存泄漏）。\n解决方案：在闭包中使用捕获列表，将 self 声明为 weak 或 unowned。",
             "综合示例：排序中的闭包"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "闭包 (Closure)"
        view.addSubview(tableView)
    }
}

extension ClosureViewController
{
    // MARK: 2.02. 嵌套函数捕获值
    @objc func test202()
    {
        let incrementByTwo = makeIncrementer(increment: 2)
        FLPrint(incrementByTwo());
        FLPrint(incrementByTwo())
    }
    
    func makeIncrementer(increment amount: Int) -> () -> Int {
        var total = 0
        func incrementer() -> Int {   // 嵌套函数
            total += amount
            return total
        }
        return incrementer
    }
    
    // MARK: 3.01. 最简单的闭包示例
    @objc func test301()
    {
        let sayHello = { (name: String) -> String in
            return "Hello, \(name)!"
        }
        FLPrint(sayHello("Hardy"))
    }
    
    // MARK: 3.02. 最简单的闭包示例
    @objc func test302()
    {
        let printMessage = {
            FLPrint("This is a closure")
        }
        printMessage() // This is a closure
    }
    
    // 定义一个函数，它接受两个整数和一个运算闭包
    func compute(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
        return operation(a, b)
    }
    
    @objc func test303()
    {
        // 调用时传入闭包
        let sum = compute(10, 20, operation: { (x, y) -> Int in
            return x + y
        })
        FLPrint(sum) // 30
    }
    
    @objc func test304()
    {
        let sum = compute(10, 20, operation: { x, y in
            return x + y
        })
    
        FLPrint(sum)
    }
    
    @objc func test305()
    {
        let sum = compute(10, 20, operation: { x, y in x + y })
        FLPrint(sum)
    }
   
    @objc func test306()
    {
        let sum = compute(10, 20, operation: { $0 + $1 })
        FLPrint(sum)
    }

    @objc func test307()
    {
        let sum = compute(10, 20) { $0 + $1 }
        FLPrint(sum)
        
        func doSomething(action: () -> Void) {
            action()
        }
        doSomething {
            FLPrint("Trailing closure!")
        }
    }
    
    @objc func test308()
    {
        func makeCounter() -> () -> Int {
            var count = 0
            let increment = { () -> Int in
                count += 1
                return count
            }
            return increment
        }

        let counter = makeCounter()
        FLPrint(counter()) // 1
        FLPrint(counter()) // 2
        FLPrint(counter()) // 3
    }
    
    @objc func test309()
    {
        var completionHandlers: [() -> Void] = []

        func addHandler(handler: @escaping () -> Void) {
            // 将闭包存储到外部数组中，函数结束后才可能被调用
            completionHandlers.append(handler)
        }

        func runAllHandlers() {
            for handler in completionHandlers {
                handler()
            }
        }

        addHandler { FLPrint("First") }
        addHandler { FLPrint("Second") }
        runAllHandlers() // 输出 First  Second
    }
    
    @objc func test310()
    {
        func logIfTrue(_ predicate: @autoclosure () -> Bool) {
            if predicate() {
                FLPrint("True")
            }
        }

        logIfTrue(2 > 1)  // 注意：直接传表达式，而不是闭包 { 2 > 1 }
    }
    
    @objc func test311()
    {
        func setupClosure() {
            // 使用 [weak self] 避免循环引用
            onTap = { [weak self] in
                guard let self = self else { return }
                FLPrint(self.name)
            }
        }
        setupClosure()
    }
    
    @objc func test312()
    {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

        // 1. 完整闭包写法
        let sorted1 = names.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
        FLPrint(sorted1)
        
        // 2. 类型推断 + 隐式返回
        let sorted2 = names.sorted(by: { s1, s2 in s1 > s2 })
        FLPrint(sorted2)
        
        // 3. 参数名称缩写
        let sorted3 = names.sorted(by: { $0 > $1 })
        FLPrint(sorted3)

        // 4. 尾随闭包 + 运算符方法（String 实现了 > 运算符，直接传入运算符函数）
        let sorted4 = names.sorted(by: >)
        FLPrint(sorted4) 
    }
}
