//
//  SystemTypeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/12.
//

import UIKit

class SystemTypeVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        dataArray = [["在Swift中，类型系统主要被划分为值类型（Value Types）和引用类型（Reference Types）两大类。这两种类型在内存管理、数据复制、以及变量间的数据共享等方面有着显著的差异。以下是对Swift中引用类型和值类型的详细解析","值类型（Value Types）","引用类型（Reference Types）"]]
        headDataArray = ["一、说明"]
    }

    func initUI()
    {
        self.title = "Value and Reference"
        view.addSubview(tableView)
    }
}

// MARK: - 一、值类型（Value Types）和 引用类型（Reference Types）
extension SystemTypeVC
{
    // MARK: 1.02. 值类型
    @objc func test102()
    {
        self.navigationController?.pushViewController(SystemValueTypeVC.init(), animated: true)
    }
    
    // MARK: 1.03. 引用类型
    @objc func test103()
    {
        self.navigationController?.pushViewController(SystemReferenceTypeVC.init(), animated: true)
    }
}
