//
//  SQLManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import Foundation
import SQLite

class SQLManager: NSObject
{
    static let manager = SQLManager()
    var db:Connection!
    let sqlFileName = "base.db"

    private override init() {
        super.init()
        objc_sync_enter(self)
        openDatabase()
        objc_sync_exit(self)
    }

    private func openDatabase() 
    {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!+"/"+sqlFileName
        print("数据库 \(dbPath)")
        if !FileManager.default.fileExists(atPath: dbPath) {
            FileManager.default.createFile(atPath: dbPath, contents: nil)
            db = try! Connection(dbPath)
        }else {
            do {
                db = try Connection(dbPath)
            }catch {
                print("数据库链接失败")
            }
        }
    }
}
