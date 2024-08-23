//
//  ExceptionViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/23.
//

import UIKit

class ExceptionViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、说明","二、详细解析"]
        dataArray = [
            [
                "在 Swift 中，try, catch, 和 throws 关键字用于异常处理，但它们的使用方式与你可能在其他编程语言中看到的有所不同。Swift 使用的是基于错误处理的机制，而不是传统的异常机制。这意味着在 Swift 中，你通常不会看到像在其他语言中那样的“抛出异常”和“捕获异常”的行为。相反，Swift 使用错误处理来响应可能失败的操作。",
            ],
            [
                "throws 关键字\n在 Swift 中，当一个函数、方法或构造器可能失败时，它会在其声明中包含 throws 关键字。这表示该函数可能会返回一个错误，调用者需要处理这个潜在的错误。但是，请注意，throws 关键字本身并不直接导致函数抛出错误；它只是告诉编译器和开发者该函数可能会失败。",
                "使用 try? 来将结果转换为可选值：\n如果你不关心错误，只想在调用成功时获取结果，你可以使用 try?。这将尝试调用函数，如果成功则返回结果的可选值（如果函数返回非可选类型，则结果将是可选类型），如果失败则返回 nil。 ",
                "使用 try! 来强制解包结果（不推荐）：\n虽然你可以使用 try! 来强制调用可能抛出错误的函数，但这通常不是一个好主意，因为它会隐藏潜在的错误，并在错误发生时导致运行时崩溃。 ",
                "try与do-catch一起使用来捕获和处理错误。"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "KeyWord"
        view.addSubview(tableView)
    }
}


extension ExceptionViewController
{
    // MARK: 2.01. throws 关键字
    @objc func test201()
    {
        do {
            let result = try mightFail()
        } catch MyError.someError {
            FLPrint("错误类型:someError")
        } catch {
            FLPrint("错误类型:otherError")
        }
    }
    
    // MyError 是一个遵循 Error 协议的枚举或结构体
    enum MyError: Error {
        case someError
    }
    
    func mightFail() throws -> String
    {
        // 假设这里有一些可能失败的逻辑
        if 1 < 0 {
            return "Success"
        } else {
            // 抛出错误
            throw MyError.someError
        }
    }
    
    // MARK: 2.02. try? 关键字
    @objc func test202()
    {
        if let result = try? mightFail() {
            // 使用 result
        } else {
            // 处理失败情况
        }
    }
    
    // MARK: 2.03. try! 关键字
    @objc func test203()
    {
        let result = try! mightFail() // 如果 mightFail() 抛出错误，这里将引发运行时错误 // Thread 1: Fatal error: 'try!' expression unexpectedly raised an error: IOS_Swift.ExceptionViewController.MyError.someError
        // 使用 result
    }
}
