//
//  FLChatDetailDao.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/23.
//

import Foundation
import SQLite
import SwiftUI


/******ChatDetailDao******/
class FLChatDetailDao
{
    /**
     * 增
     */
    func insertChatListTable(chatID : String, model : FLChatMsgModel) -> Bool
    {
        var success = false
        FLDatabaseManager.shared.perform { con in
            do {
                let imgWidthDouble = Double(model.imgWidth)
                let imgHeightDouble = Double(model.imgHeight)
                try con.run("INSERT INTO \(chatDetailTableName)\(chatID)(friendId,avatar, nickName, contentStr, lastContent,msgType,isMe,mediaTime,imgWidth,imgHeight)VALUES(?,?,?,?,?,?,?,?,?,?)",model.friendId,model.avatar,model.nickName,model.contentStr,model.lastContent,model.msgType.rawValue,model.isMe,model.mediaTime,imgWidthDouble,imgHeightDouble)//
                success = true
            } catch {
                FLPrint("Insert failed: \(error)")
            }
        }
        return success
    }
    
    /**
     * 删除
     */
    func dropChat(chatTableName: String) -> Bool
    {
        var success = false
        FLDatabaseManager.shared.perform { con in
            do {
                let sql = "DROP TABLE IF EXISTS \(chatTableName)"
                try con.run(sql)
                success = true
            } catch {
                FLPrint("Drop table failed: \(error)")
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
        return FLDatabaseManager.shared.perform { con in
            let stmt = try! con.prepare("SELECT * FROM \(chatDetailTableName)\(userID)")
            while let row = stmt.next() {
                let item = FLChatMsgModel.init();
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
                item.avatar = row[2] as? String ?? ""
                item.nickName = row[3] as? String ?? ""
                item.contentStr = row[4] as? String ?? ""
                item.lastContent = row[5] as? String ?? ""
                if let msgTypeInt = row[6] as? Int64, let safeMsgType = Int(exactly: msgTypeInt) {
                    if let msgType = FLMessageType(rawValue: safeMsgType) {
                        item.msgType = msgType
                    } else {
                        item.msgType = .msg_unknown
                    }
                } else {
                    item.msgType = .msg_unknown
                }
                
                if let is_me = row[7] as? Int64, let safeIsme = Int(exactly: is_me) {
                    if safeIsme == 1 {
                        item.isMe = true
                    }else{
                        item.isMe = false
                    }
                }else{
                    item.isMe = false
                }
                item.mediaTime = row[8] as? String ?? ""
                // 确保从数据库中提取的值可以安全地转换为 Double
                if let imgWidthDouble = row[9] as? Int64, let safeMsgType = Int(exactly: imgWidthDouble) {
                    item.imgWidth = Int(imgWidthDouble)
                }else{
                    print("无法将 row[8] 转换为 Int64")
                }
                if let imgHeightDouble = row[10] as? Int64, let safeMsgType = Int(exactly: imgHeightDouble) {
                    item.imgHeight = Int(CGFloat(imgHeightDouble))
                }else{
                    print("无法将 row[9] 转换为 Int64")
                }
                items.append(item)
            }
            return items
        }
    }
}



