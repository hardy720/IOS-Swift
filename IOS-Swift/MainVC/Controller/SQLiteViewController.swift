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
            ["增","删","改","查"]
        ]
    }
}

// MARK: - 一、使用 SQLite.swift.
extension SQLiteViewController
{
    // MARK:2.0.201. 创建表格
    @objc func test201()
    {
        DatabaseManager.shared.setup();
       
        if let arr = ChatListDao.init().fetchChatListTable() {
            for item in arr {
                print(item.id)
                print(item.avatar)
                print(item.nickName)
            }
        } else {
            print("没有获取到数据")
        }
        return
        
//        ChatListDao.init().fetchChatListTable(id: 0);
        
//        let isOk = ChatListDao.init().deleteChatListTable(id: 100)
//        print("---\(isOk)")
//
//        for num in 1...100 {
//            let model = ChatListModel.init()
//            model.avatar = "https://img1.baidu.com/it/u=1624963289,2527746346&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750"
//            model.nickName = "nickName"
//            model.lastContent = "content"
//            let isok = ChatListDao.init().insertChatListTable(model: model)
//            print("---\(isok)")
//        }
    }
}
