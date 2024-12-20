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
                let currentDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone.current
                let currentTimestamp = formatter.string(from: currentDate)
                try con.run("""
                        INSERT INTO \(chatListTableName) (friendId, avatar, nickName, lastContent,messageAlert,updatedAt)
                        VALUES (?, ?, ?, ?, ?, ?)
                        ON CONFLICT(friendId) DO UPDATE SET
                                avatar = EXCLUDED.avatar,
                                nickName = EXCLUDED.nickName,
                                lastContent = EXCLUDED.lastContent,
                                messageAlert = EXCLUDED.messageAlert,
                                updatedAt = ?
                        """, model.friendId, model.friendAvatar, model.friendName, model.lastText,
                            model.messageAlert,
                            currentTimestamp,
                            currentTimestamp
                )
                success = true
            } catch {
                FLPrint("Insert/Update failed: \(error)")
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
                let sql = "UPDATE \(chatListTableName) SET avatar=?, nickName=?, messageAlert=?,lastContent=?,updatedAt=CURRENT_TIMESTAMP WHERE friendId =?"
                try con.run(sql, model.friendAvatar,model.friendName,model.messageAlert,model.lastText,model.friendId)
                success = true
            } catch {
                FLPrint("update failed: \(error)")
            }
        }
        return success
    }
    
    func updateChatListMessageAlert(model: FLChatListModel) -> Bool
    {
         var success = false
        FLDatabaseManager.shared.perform { con in
             do {
                 let sql = """
                 UPDATE \(chatListTableName)
                 SET
                     messageAlert = ?,
                     updatedAt = CURRENT_TIMESTAMP
                 WHERE friendId = ?
                 """
                 try con.run(sql, model.messageAlert, model.friendId)
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
                if let friendId = row[1] as? Int64, let safeId = Int(exactly: friendId) {
                    item.friendId = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                item.friendAvatar = row[2] as? String ?? ""
                item.friendName = row[3] as? String ?? ""
                item.lastText = row[4] as? String ?? ""
                if let messageAlert = row[5] as? Int64, let safeId = Int(exactly: messageAlert) {
                    item.messageAlert = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                item.updateTime = row[6] as? String ?? ""
                items.append(item)
            }
            return items
        }
    }
    
    /**
     * 查询
     * 根据FriendID查询
     */
    func fetchChatByFriendID(friendID:Int) -> FLChatListModel?
    {
        return FLDatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatListTableName) WHERE friendId = ?").bind(friendID)
            let chatModel = FLChatListModel.init()
            if let row = stmt.next() {
                if let id = row[0] as? Int64, let safeId = Int(exactly: id) {
                    chatModel.id = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                if let friendId = row[1] as? Int64, let safeId = Int(exactly: friendId) {
                    chatModel.friendId = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                chatModel.friendAvatar = row[2] as? String ?? ""
                chatModel.friendName = row[3] as? String ?? ""
                chatModel.lastText = row[4] as? String ?? ""
                if let messageAlert = row[5] as? Int64, let safeId = Int(exactly: messageAlert) {
                    chatModel.messageAlert = safeId
                } else {
                    FLPrint("ID value is too large to fit in an Int")
                }
                chatModel.updateTime = row[6] as? String ?? ""
            }
            return chatModel
        }
    }
}
