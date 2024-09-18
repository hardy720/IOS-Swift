//
//  DatabaseManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import Foundation
import SQLite

let chatListTableName = "ChatListTable"
let chatDetailTableName = "chart_"

class DatabaseManager
{
    // 单例实例
    static let shared = DatabaseManager()
        
    // 私有初始化器，防止外部创建实例
    private init() {}
       
    public lazy var db: Connection? =
    {
        do {
            return try Connection(getDatabasePath)
        } catch {
            print("Unable to connect to database: \(error)")
            return nil
        }
    }()
    
    public func perform<T>(_ block: @escaping (Connection) throws -> T) -> T?
    {
        var result: T?
        do {
            result = try block(db!)
        } catch {
            print("Database error: \(error)")
        }
        return result
    }
    
    func setup()
    {
        do {
            try db?.run("CREATE TABLE IF NOT EXISTS \(chatListTableName) (id integer primary key autoincrement, avatar text, nickName text, lastContent text)")
        } catch {
            print("Failed to set up database: \(error)")
        }
    }
    
    func createChat(userID : String)
    {
        do {
            try db?.run("CREATE TABLE IF NOT EXISTS \(chatDetailTableName)\(userID) (id integer primary key autoincrement, avatar text, nickName text, contentStr text,lastContent text,msgType integer,isMe integer)")
        } catch {
            print("Failed to set up database: \(error)")
        }
    }
}

/******ChatListDao******/
class ChatListDao
{
    /**
     * 增
     */
    func insertChatListTable(model:FLChatListModel) -> Bool
    {
        var success = false
        DatabaseManager.shared.perform { con in
            do {
                try con.run("INSERT INTO \(chatListTableName)(avatar, nickName, lastContent)VALUES(?,?,?)",model.avatar,model.nickName,model.lastContent)
                success = true
            } catch {
                print("Insert failed: \(error)")
            }
        }
        return success
    }
    
    /**
     * 删
     */
    func deleteChatListTable(id:Int) -> Bool
    {
        var success = false
        DatabaseManager.shared.perform { con in
            do {
                try con.run("DELETE FROM \(chatListTableName) WHERE id = ?", id)
                success = true
            } catch {
                print("deletete failed: \(error)")
            }
        }
        return success
    }
    
    /**
     * 改
     */
    func updateChatListTable(model:FLChatListModel) -> Bool
    {
        var success = false
        DatabaseManager.shared.perform { con in
            do {
                let sql = "UPDATE \(chatListTableName) SET avatar=?, nickName=?, lastContent=? WHERE id =?"
                try con.run(sql, model.avatar,model.nickName,model.lastContent,model.id)
                success = true
            } catch {
                print("update failed: \(error)")
            }
        }
        return success
    }
    
    
    /**
     * 查
     * 查询所有
     */
    func fetchChatListTable() -> [FLChatListModel]?
    {
        var items = [FLChatListModel]()
        return DatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatListTableName)")
            while let row = stmt.next() {
                let item = FLChatListModel.init();
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    item.id = safeId
                } else {
                    print("ID value is too large to fit in an Int")
                }
                item.avatar = row[1] as? String ?? ""
                item.nickName = row[2] as? String ?? ""
                item.lastContent = row[3] as? String ?? ""
                items.append(item)
            }
            return items
        }
    }
    
    /**
     * 查询
     * 根据ID查询
     */
    func fetchChatByID(chatID:Int) -> FLChatListModel?
    {
        return DatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatListTableName) WHERE id = ?").bind(chatID)
            let chatModel = FLChatListModel.init()
            if let row = stmt.next() {
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    chatModel.id = safeId
                } else {
                    print("ID value is too large to fit in an Int")
                }
                chatModel.avatar = row[1] as? String ?? ""
                chatModel.nickName = row[2] as? String ?? ""
                chatModel.lastContent = row[3] as? String ?? ""
            }
            return chatModel
        }
    }
}

/******ChatDetailDao******/
class ChatDetailDao
{
    /**
     * 增
     */
    func insertChatListTable(chatID : String, model : FLChatMsgModel) -> Bool
    {
        var success = false
        DatabaseManager.shared.perform { con in
            do {
                try con.run("INSERT INTO \(chatDetailTableName)\(chatID)(avatar, nickName, contentStr, lastContent,msgType,isMe)VALUES(?,?,?,?,?,?)",model.avatar,model.nickName,model.contentStr,model.lastContent,model.msgType.rawValue,model.isMe)//
                success = true
            } catch {
                print("Insert failed: \(error)")
            }
        }
        return success
    }
    
    /**
     * 查
     * 查询所有
     */
    func fetchChatDetailTable(userID : String) -> [FLChatMsgModel]?
    {
        var items = [FLChatMsgModel]()
        return DatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatDetailTableName)\(userID)")
            while let row = stmt.next() {
                let item = FLChatMsgModel.init();
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    item.id = safeId
                } else {
                    print("ID value is too large to fit in an Int")
                }
                item.avatar = row[1] as? String ?? ""
                item.nickName = row[2] as? String ?? ""
                item.contentStr = row[3] as? String ?? ""
                item.lastContent = row[4] as? String ?? ""
                if let msgTypeInt = row[5] as? Int64, let safeMsgType = Int(exactly: msgTypeInt) {
                    if let msgType = FLMessageType(rawValue: safeMsgType) {
                        item.msgType = msgType
                    } else {
                        item.msgType = .msg_unknown
                    }
                } else {
                    item.msgType = .msg_unknown
                }
                
                if let is_me = row[6] as? Int64, let safeIsme = Int(exactly: is_me) {
                    if safeIsme == 1 {
                        item.isMe = true
                    }else{
                        item.isMe = false
                    }
                }else{
                    item.isMe = false
                }
                items.append(item)
            }
            return items
        }
    }
}



