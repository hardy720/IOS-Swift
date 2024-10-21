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
        FLDatabaseManager.shared.setup();
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
    // MARK:2.0.201. 增
    @objc func test201()
    {
        let model = FLChatListModel.init()
        model.friendAvatar = "https://img1.baidu.com/it/u=1624963289,2527746346&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750"
        model.friendName = "nickName"
        model.lastText = "content"
        let isok = ChatListDao.init().insertChatListTable(model: model)
        FLPrint("新增是否成功:\(isok)")
    }
    
    // MARK:2.0.202. 删
    @objc func test202()
    {
        let isOk = ChatListDao.init().deleteChatListTable(id: 1)
        FLPrint("删除是否成功:\(isOk)")
    }
    
    // MARK:2.0.203. 改
    @objc func test203()
    {
        let model = FLChatListModel.init()
        model.id = 30
        model.friendName = "修改后"
        let isOk = ChatListDao.init().updateChatListTable(model: model)
        FLPrint("修改是否成功:\(isOk)")
    }
    
    // MARK:2.0.204. 查
    @objc func test204()
    {
        let ss = ChatListDao.init().fetchChatByID(chatID: -8000)
        if let arr = ChatListDao.init().fetchChatListTable() {
            for item in arr {
                FLPrint(item.id)
                FLPrint(item.friendAvatar)
                FLPrint(item.friendName)
            }
        } else {
            FLPrint("没有获取到数据")
        }
    }
}
