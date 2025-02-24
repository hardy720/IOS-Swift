//
//  OptionalVSNilVC.swift
//  IOS-Swift
//
//  Created by hardy on 2025/2/24.
//

import UIKit

class OptionalVSNilVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = [
            "一、说明",
            "二、Objective-C 的 nil",
            "三、Swift 的 Optional",
            "四、强制解包与可选链",
            "五、可选绑定与空合并运算符"
        ]
        dataArray = [
            ["Swift 的 Optional 类型系统是语言设计的核心特性之一，它与 Objective-C 的 nil 有显著区别，体现了 Swift 对安全性和表达力的重视。以下是对比详解："],
            ["特点：\n动态性：OC 的 nil 是一个指向空对象的指针，可以在运行时传递和使用。\n隐式行为：向 nil 发送消息不会崩溃，而是静默失败（返回 nil 或 0）。\n无类型信息：nil 本身没有类型信息，任何对象指针都可以是 nil.",
            "示例:\nNSString *name = nil;\nNSLog('Name length: %lu', [name length]); // 不会崩溃，输出 0",
            "问题:\n隐藏的崩溃风险：虽然向 nil 发送消息不会崩溃，但如果 nil 被传递到不支持它的地方（如 C 函数或非对象类型），可能导致崩溃。\n缺乏编译时检查：编译器无法强制检查 nil 的使用，容易导致逻辑错误。"],
            ["设计哲学:\n显式性：Optional 是一种类型，表示值可能存在（some）或不存在（none）。\n安全性：编译器强制处理 Optional，避免运行时意外崩溃。\n类型系统集成：Optional 是泛型枚举，与 Swift 的类型系统无缝结合。","语法糖:\nT? 是 Optional<T> 的简写。\nnil 是 Optional.none 的简写。","示例"],
            ["强制解包（Forced Unwrapping）:\n使用 ! 强制解包 Optional，如果值为 nil，会触发运行时崩溃。\n适用场景：确定值一定存在时（如 UI 初始化完成后）。\n风险：滥用会导致崩溃。",
            "可选链（Optional Chaining）:\n使用 ?. 安全访问 Optional 的属性或方法。\n如果值为 nil，整个表达式返回 nil，不会崩溃。\n适用场景：不确定值是否存在时。"],
            ["可选绑定（Optional Binding）:\n使用 if let 或 guard let 安全解包 Optional。\n适用场景：需要解包后使用值的场景。","空合并运算符（Nil-Coalescing Operator）:\n使用 ?? 提供默认值。\n适用场景：解包失败时使用备用值","利用 guard 提前退出:使用 guard let 在函数开头处理 Optional，避免嵌套过深。"]
        ]
    }
    
    func initUI()
    {
        self.title = "Optional vs OC 的 nil（强制解包/可选链的安全哲学）详解"
        view.addSubview(tableView)
    }
}

extension OptionalVSNilVC
{
    @objc func test303()
    {
        var name: String? = "Alice"
        FLPrint(name?.count as Any) // 输出 Optional(5)
        name = nil
        FLPrint(name?.count as Any) // 输出 nil
    }
    
    @objc func test401()
    {
        let name: String? = "Alice"
        FLPrint(name!) // 输出 "Alice"

        let invalidName: String? = nil
        FLPrint(invalidName!) // 运行时崩溃
    }
    @objc func test402()
    {
        let name: String? = "Alice"
        FLPrint(name?.count as Any) // 输出 Optional(5)

        let invalidName: String? = nil
        FLPrint(invalidName?.count as Any) // 输出 nil
    }
    
    @objc func test501()
    {
        let name: String? = "Alice"
        if let unwrappedName = name {
            FLPrint("Name is \(unwrappedName)")
        } else {
            FLPrint("Name is nil")
        }
    }
    
    @objc func test502()
    {
        let name: String? = nil
        let validName = name ?? "Unknown"
        print(validName) // 输出 "Unknown"
    }
    
    @objc func test503()
    {
        printNameLength(name: nil)
    }
    
    func printNameLength(name: String?) {
        guard let name = name else {
            print("Name is nil")
            return
        }
        print("Name length: \(name.count)")
    }
}
