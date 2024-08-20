//
//  KeyWordViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/15.
//

import UIKit

class KeyWordViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、@discardableResult"]
        dataArray = [["在Swift中，@discardableResult 属性是一个类型属性（type attribute），用于标记函数或方法的返回值是可以被忽略的。这个属性主要用在那些即便没有使用其返回值也不会导致逻辑错误或资源泄露的情况下。它告诉编译器和开发者，在某些情况下，调用这个函数或方法并忽略其返回值是安全的。","为什么需要 @discardableResult？在Swift的严格编译环境中，如果函数或方法设计有返回值，但调用者没有使用这个返回值，编译器通常会发出警告。这是为了帮助开发者避免可能的逻辑错误或资源泄露。然而，在某些情况下，函数可能仅用于其副作用（side effects），如发送日志、更新UI等，并不依赖于其返回值。在这些情况下，每次调用都强制处理返回值可能是不必要的，甚至可能导致代码变得冗长和难以理解。","如何使用 @discardableResult？可以在函数或方法的声明前添加 @discardableResult 属性来标记它。这样，即便调用者忽略了其返回值，编译器也不会发出警告。"]]
    }
    
    func initUI()
    {
        self.title = "KeyWord"
        view.addSubview(tableView)
    }
}

// MARK: - 一、@discardableResult
extension KeyWordViewController
{
    // MARK: 1.01. 引用类型和值类型
    @objc func test101()
    {
        // 调用 someFunction 时可以忽略其返回值，而不会收到编译警告
        someFunction()
    }
    
    @discardableResult
    func someFunction() -> String 
    {
        return "Hello, World!"
    }
}
