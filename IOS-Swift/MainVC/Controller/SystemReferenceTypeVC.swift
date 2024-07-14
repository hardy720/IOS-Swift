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
        
    }
    
    func initUI()
    {
        self.title = "引用类型（ReferenceType）"
        view.addSubview(tableView)
    }
}

// MARK: - 一、语言基础
extension SystemReferenceTypeVC
{
    // MARK: 1.01. 引用类型和值类型
    @objc func test101()
    {
        
    }
    
}
