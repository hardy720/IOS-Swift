//
//  ProtocolAndExtensionVC.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/4/23.
//

import UIKit

class ProtocolAndExtensionVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = [
            "一、说明",
            "二、用法"
        ]
        dataArray = [
            [
                "协议定义了一组方法、属性的蓝图，而扩展可以给已有类型（包括协议）添加新功能。",
            ],
            [
                "协议的基本用法",
                "协议扩展（Protocol Extension）:为协议提供默认实现，这是 Swift 面向协议编程（POP）的核心。",
                "扩展（Extension）给现有类型添加功能"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "协议（Protocol）与扩展（Extension）"
        view.addSubview(tableView)
    }
}

extension ProtocolAndExtensionVC
{
    protocol Flyable {
        var maxAltitude: Int { get }      // 只读属性要求
        func fly()                         // 方法要求
        mutating func land()               // 可能修改自身的变异方法
    }

    struct Bird: Flyable {
        var maxAltitude: Int { return 1000 }
        func fly() { FLPrint("鸟在飞") }
        mutating func land() { FLPrint("鸟着陆") }
    }

    struct Person: Greetable {
        var name: String
        // 可以不用实现 greet()，因为有了默认实现
    }
    
    @objc func test101()
    {
        let bird = Bird()
        bird.fly()
        
        let alice = Person(name: "Alice")
        alice.greet()
        
        FLPrint(5.isEven)
        FLPrint(5.squared())
    }
}

extension Int {
    // 添加计算属性
    var isEven: Bool {
        return self % 2 == 0
    }
    // 添加方法
    func squared() -> Int {
        return self * self
    }
}

protocol Greetable {
    var name: String { get }
    func greet()
}

// 为协议提供默认实现
extension Greetable {
    func greet() {
        FLPrint("Hello, I'm \(name)")
    }
}
