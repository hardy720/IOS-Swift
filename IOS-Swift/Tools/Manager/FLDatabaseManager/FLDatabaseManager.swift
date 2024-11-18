//
//  FLDatabaseManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import Foundation
import SQLite

let chatListTableName = "ChatListTable"
let chatDetailTableName = "chart_"

class FLDatabaseManager
{
    // 单例实例
    static let shared = FLDatabaseManager()
        
    // 私有初始化器，防止外部创建实例
    private init() {}
       
    public lazy var db: Connection? =
    {
        do {
            if let path = getDatabasePath {
                return try Connection(path)
            } else {
                FLPrint("Not getting a sandbox path to create a database.")
                return nil
            }
        } catch {
            FLPrint("Unable to connect to database: \(error)")
            return nil
        }
    }()
    
    public func perform<T>(_ block: @escaping (Connection) throws -> T) -> T?
    {
        var result: T?
        do {
            result = try block(db!)
        } catch {
            FLPrint("Database error: \(error)")
        }
        return result
    }
    
    // 创建聊天列表数据库
    func setup()
    {
        do {
            try db?.run("""
                CREATE TABLE IF NOT EXISTS \(chatListTableName) (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    friendId INTEGER UNIQUE,
                    avatar TEXT,
                    nickName TEXT,
                    lastContent TEXT,
                    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
        } catch {
            FLPrint("Failed to set up database: \(error)")
        }
    }
    
    // 创建聊天详情数据库
    func createChat(userID : String)
    {
        do {
            try db?.run("CREATE TABLE IF NOT EXISTS \(chatDetailTableName)\(userID) (id integer primary key autoincrement,friendId integer, avatar text, nickName text, contentStr text,lastContent text,msgType integer,isMe integer,mediaTime text,imgWidth integer,imgHeight integer)")
        } catch {
            FLPrint("Failed to set up database: \(error)")
        }
    }
    
    // 检查数据库表格是否存在.
    func tableExists(tableName: String) -> Bool
    {
        do {
            // 尝试执行一个查询，该查询会返回所有名为给定名称的表
            let exists = try db?.scalar("SELECT name FROM sqlite_master WHERE type='table' AND name=?", tableName) != nil
            return exists
        } catch {
            print("Error checking if table exists: \(error)")
            return false
        }
    }
}
