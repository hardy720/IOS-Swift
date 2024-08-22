//
//  SQLiteViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class SQLiteViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initUI()
    {
        self.title = "SQLite.swift"
        view.addSubview(tableView)
    }
    
    func initData()
    {
        headDataArray =
        [
            "一、SQLite.swift说明",
            "二、SQLite.swift使用"
        ]
        
        dataArray =
        [
            ["SQLite.swift 是一个 Swift 语言的 SQLite 数据库封装库，它提供了更加简洁和安全的接口来操作 SQLite 数据库。与直接使用 SQLite C API 相比，SQLite.swift 使得数据库操作更加容易理解和编写"],
            ["123"]
        ]
    }
}

// MARK: - 一、使用 SQLite.swift.
extension SQLiteViewController
{
    // MARK:1.0.101. 加载图片
    @objc func test201()
    {
        
    }
}
