//
//  SystemReferenceTypeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/12.
//

import UIKit

class SystemReferenceTypeVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、说明","二、类（Class）","三、弱引用（Weak References）"]
        dataArray = [["在 Swift 中，引用类型（Reference Types）与值类型（Value Types）是两种基本的内存管理方式。引用类型不直接存储数据，而是存储对数据的引用（即内存地址）。这意味着当你将一个引用类型的变量赋值给另一个变量时，两个变量实际上引用的是内存中同一个对象。因此，对其中一个变量所做的修改也会影响到另一个变量所引用的对象。\nSwift 中的引用类型主要包括类（Class）和函数类型（Function Types）。不过，函数类型虽然在概念上也是引用类型，但在实际使用中其行为可能更接近于值类型，因为 Swift 会对函数进行复制，而不是仅仅复制引用。"],["类是 Swift 中最常用的引用类型。类可以包含属性和方法，以及构造器、析构器、继承、多态等特性。当你创建一个类的实例时，这个实例在内存中有一个唯一的地址，并且可以通过变量（引用）来访问这个实例。"],["在引用类型中，弱引用（通过 weak 关键字实现）是一种特殊的引用，它不会阻止其引用的对象被销毁。当对象不再有任何强引用时，它会被自动销毁，此时其弱引用会被设置为 nil。这主要用于解决循环引用问题。"]]
    }
    
    func initUI()
    {
        self.title = "引用类型（ReferenceType）"
        view.addSubview(tableView)
    }
}

// MARK: - 一、引用类型（ReferenceType）
extension SystemReferenceTypeVC
{
    // MARK: 1.01. 引用类型和值类型
    @objc func test101()
    {
        
    }
    
    // MARK: 2.01. 类
    @objc func test201()
    {
        var instance1 = MyClass(value: 10)
        var instance2 = instance1 // instance1 和 instance2 引用同一个对象
        instance2.value = 20 // 这会改变 instance1.value 的值，因为它们引用的是同一个对象
        FLPrint(instance1.value) // 输出: 20
    }
    
    // MARK: 3.01. 弱引用
    @objc func test301()
    {
        var parent: Parent? = Parent()
        let child = Child()
        parent?.child = child
        child.parent = parent
        // 此时解除对 parent 的强引用
        parent = nil
        // 由于 child 对 parent 的引用是弱引用，parent 会被销毁
        // 然后 child 也会因为失去了对它的最后一个引用而被销毁
    }
}

class MyClass 
{
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

class Parent 
{
    var child: Child?
    deinit {
        FLPrint("Parent is being deinitialized")
    }
}

class Child 
{
    weak var parent: Parent?
    deinit {
        FLPrint("Child is being deinitialized")
    }
}
