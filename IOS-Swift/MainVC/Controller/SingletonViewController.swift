//
//  SingletonViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class SingletonViewController: FLBaseViewController {

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
            "二、实现单例模式的步骤",
            "三、创建使用"
        ]
        dataArray =
        [
            [
                "在Swift中，单例模式是一种常用的设计模式，用于确保一个类仅有一个实例，并提供一个全局访问点来获取这个实例。在iOS和macOS开发中，单例模式经常用于管理共享资源，如数据库连接、文件操作、缓存、配置信息等。",
            ],
            [
                "私有化构造函数：确保类不能被外部代码实例化。",
                "创建一个静态实例变量：用于存储类的唯一实例。",
                "提供一个公共的类方法：用于获取类的唯一实例，这个方法会在第一次调用时创建实例，并在之后的调用中返回这个实例。"
            ],
            [
                "swift单例实现示例",
                "私有化构造函数 (private init() {}):\n通过将构造函数私有化，我们防止了外部代码通过new关键字或调用构造函数来创建类的实例。这是实现单例模式的第一步。",
                "静态实例变量 (static let shared = Singleton()): \n我们使用static关键字来声明一个类级别的变量，这意味着这个变量属于类本身而不是类的任何特定实例。\nlet关键字表示这个变量是一个常量，一旦被初始化后就不能再被重新赋值。这对于单例来说是必要的，因为我们想要确保只有一个实例。/nlazy关键字（虽然在这个例子中没有明确写出，但在Swift中，静态的let属性在声明时就会立即初始化，并且由于Swift的编译器和运行时保证，静态的let属性在初始化时就是线程安全的，所以通常不需要显式地添加lazy。但如果你需要更复杂的初始化逻辑，并且想要延迟初始化直到第一次访问时，那么可以使用lazy var而不是let，不过对于单例来说，let通常是更好的选择。）\nSingleton()是类构造函数的调用，它在这里用于初始化类的唯一实例。由于构造函数是私有的，这个调用只能在类内部进行。",
                "其他属性和方法: \n类可以包含其他属性和方法，这些属性和方法将共享给类的唯一实例。在这个例子中，我们添加了一个showMessage方法来展示如何使用单例实例的方法。",
                "使用单例: \n我们通过Singleton.shared来访问单例的实例。无论我们访问多少次Singleton.shared，它都会返回同一个实例。/n我们可以通过调用实例的方法来使用单例提供的功能，比如在这个例子中的showMessage方法。"
            ]
        ]
    }

    func initUI()
    {
        self.title = "singleton development model"
        view.addSubview(tableView)
    }
}

// MARK: - 三、单例创建使用
extension SingletonViewController
{
    // MARK:3.0.301. 创建单例.
    @objc func test301()
    {
        let instance1 = Singleton.shared
        let instance2 = Singleton.shared
        FLPrint(instance1 === instance2)
//        FLPrint(instance1.getMessage())
    }
}
