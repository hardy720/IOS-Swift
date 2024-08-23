//
//  DatabaseManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import Foundation
import SQLite

class DatabaseManager
{
    // 单例实例
    static let shared = DatabaseManager()
    
    // 串行队列用于同步数据库访问
    private let dbQueue = DispatchQueue(label: "com.example.databaseQueue")
    
//    // 数据库连接（可选，因为可能在运行时打开和关闭）
//    private var db: Connection?
    
    // 私有初始化器，防止外部创建实例
    private init() {}
    
    // 打开数据库连接（通常在应用启动时调用）
    func openDatabase(atPath path: String = getDatabasePath) throws -> Connection
    {
        let db = try Connection(path)
        FLPrint("Database opened successfully at \(path).")
        return db
    }
}

class ChatListDao
{
    func creatChatListTable() {
        do {
            let db = try DatabaseManager.shared.openDatabase()
            let createTableSQL = """
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    userName TEXT NOT NULL,
                    userAge INTEGER NOT NULL
                );
                """
            try db.run(createTableSQL)
        } catch let error {
            // 处理 error
            print("An error occurred: \(error)")
        }
    }
    
    func insertUser(userName: String, userAge: Int)
    {
        self.creatChatListTable()
        do {
            let db = try DatabaseManager.shared.openDatabase()
            let insertSQL = "INSERT INTO users (userName, userAge) VALUES (?, ?);"
            try db.run(insertSQL, [userName, userAge]) 
        }catch let error {
            // 处理 error
            print("An error occurred: \(error)")
        }
    }
}




