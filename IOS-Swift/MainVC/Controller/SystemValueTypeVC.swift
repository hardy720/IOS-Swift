//
//  SystemValueTypeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/12.
//

import UIKit

class SystemValueTypeVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、说明"]
        dataArray = [["在Swift中，值类型是指当它们被赋值给新变量或传递给函数时，会进行完整数据复制的类型。这意味着每个变量或常量都拥有其值的独立副本，对其中一个的修改不会影响到另一个。Swift中的值类型主要包括结构体（Struct）、枚举（Enum）以及元组（Tuple），但基本数据类型（如Int、Float、Double、Bool、String等）虽然看起来像是内置类型，实际上在Swift的设计哲学下，它们也被视为值类型。","结构体（Struct）","枚举（Enum）","元组（Tuple）"]]
    }
    
    func initUI()
    {
        self.title = "值类型（ValueType）"
        view.addSubview(tableView)
    }
}

// MARK: - 一、值类型（ValueType）
extension SystemValueTypeVC
{
    // MARK: 1.02. 结构体（Struct）
    @objc func test102()
    {
        self.navigationController?.pushViewController(StructDetailVC.init(), animated: true)
    }
}
