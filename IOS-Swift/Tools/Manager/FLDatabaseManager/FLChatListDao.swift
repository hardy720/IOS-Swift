//
//  FLChatListDao.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/23.
//

import Foundation

/******ChatListDao******/
class FLChatListDao
{
    /**
     * 增
     */
    func insertChatListTable(model:FLChatListModel) -> Bool
    {
        var success = false
        FLDatabaseManager.shared.perform { con in
            do {
                try con.run("INSERT INTO \(chatListTableName)(avatar, nickName, lastContent)VALUES(?,?,?)",model.friendAvatar,model.friendName,model.lastText)
                success = true
            } catch {
                FLPrint("Insert failed: \(error)")
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
        FLDatabaseManager.shared.perform { con in
            do {
                try con.run("DELETE FROM \(chatListTableName) WHERE id = ?", id)
                success = true
            } catch {
                FLPrint("deletete failed: \(error)")
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
        FLDatabaseManager.shared.perform { con in
            do {
                let sql = "UPDATE \(chatListTableName) SET avatar=?, nickName=?, lastContent=? WHERE id =?"
                try con.run(sql, model.friendAvatar,model.friendName,model.lastText,model.id)
                success = true
            } catch {
                FLPrint("update failed: \(error)")
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
        return FLDatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatListTableName)")
            while let row = stmt.next() {
                let item = FLChatListModel.init();
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    item.id = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                item.friendAvatar = row[1] as? String ?? ""
                item.friendName = row[2] as? String ?? ""
                item.lastText = row[3] as? String ?? ""
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
        return FLDatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatListTableName) WHERE id = ?").bind(chatID)
            let chatModel = FLChatListModel.init()
            if let row = stmt.next() {
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    chatModel.id = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                chatModel.friendAvatar = row[1] as? String ?? ""
                chatModel.friendName = row[2] as? String ?? ""
                chatModel.lastText = row[3] as? String ?? ""
            }
            return chatModel
        }
    }
}
