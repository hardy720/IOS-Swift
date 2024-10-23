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
    
    func setup()
    {
        do {
            try db?.run("CREATE TABLE IF NOT EXISTS \(chatListTableName) (id integer primary key autoincrement,friendId  avatar text, nickName text, lastContent text)")
        } catch {
            FLPrint("Failed to set up database: \(error)")
        }
    }
    
    func createChat(userID : String)
    {
        do {
            try db?.run("CREATE TABLE IF NOT EXISTS \(chatDetailTableName)\(userID) (id integer primary key autoincrement, avatar text, nickName text, contentStr text,lastContent text,msgType integer,isMe integer,mediaTime text)")
        } catch {
            FLPrint("Failed to set up database: \(error)")
        }
    }
}
