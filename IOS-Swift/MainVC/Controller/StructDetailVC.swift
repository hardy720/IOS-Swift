//
//  StructDetailVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/12.
//

import UIKit

class StructDetailVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        dataArray = [
            ["Swift 中的 struct 是一种复合数据类型，用于封装多个不同类型的值到一个单一的类型中。struct 在 Swift 中是值类型（Value Type），意味着当你将一个 struct 赋值给另一个变量或者传递给函数时，实际上是在复制这个 struct 的一个副本。这与类（Class）不同，类是引用类型（Reference Type），它们传递的是引用而非副本。"],
            ["定义一个 struct 非常简单，使用 struct 关键字后跟结构体的名称，在大括号 {} 中定义其属性和方法。访问 struct 的属性和方法 通过点语法（.）访问 struct 的属性或方法。"],
            ["值类型 vs 引用类型：struct 是值类型，而 class 是引用类型。这意味着当你将 struct 赋值给新变量时，你实际上是在复制它；而当你将 class 赋值给新变量时，你只是创建了另一个引用指向同一个对象。",
             "继承：class 支持继承，而 struct 不支持。struct 可以实现协议（Protocols），但不能继承自其他 struct 或 class。",
             "默认成员wise初始化器：如果你没有在 struct 中定义任何自定义的初始化器，Swift 会自动为你提供一个成员wise初始化器（Memberwise Initializer），允许你通过直接传递属性值来创建 struct 的实例。这在 class 中不会发生，因为 class 需要明确的初始化器。"],
            ["当你的数据结构主要是用来封装数据时，并且这些数据需要被复制而不是被共享时，使用 struct。",
            "当你的数据结构较小，并且不需要复杂的继承关系时，struct 是一个很好的选择。",
            "在需要性能优化的场合，由于 struct 是值类型，它们可以被存储在栈（Stack）上，而 class 由于是引用类型，通常存储在堆（Heap）上，这可能会导致额外的性能开销。"]
        ]
        headDataArray = ["一、说明","二、定义struct","三、结构体（struct）与类（class）的主要区别","四、结构体（struct）的使用场景"]
    }
    
    func initUI()
    {
        self.title = "Struct"
        view.addSubview(tableView)
    }
}

// MARK: - 二、定义Struct
extension StructDetailVC
{
    // 定义一个Person Struct
    struct Person {
        var name: String
        var age: Int
          
        // 构造函数（初始化器）
        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
          
        // 方法
        func play() {
            FLPrint("Hello, my name is \(name) and I am \(age) years old.And I am Playing")
        }
    }
    
    // MARK: 2.01、实例化 struct
    // 使用 struct 的名称和圆括号中的参数来创建其实例，这些参数对应于 struct 初始化器中的参数。
    @objc func test201()
    {
        let person = Person(name: "Hardy", age: 18)
        FLPrint("创建了Person Struct. name=\(person.name),age=\(person.age)")
        person.play()
    }
}
