//
//  AppDelegate.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/6.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /**
         * 数据库设置
         */
        self.setDatabase()
        
        /**
         * test
         */
        self.test1()
        return true
    }
    
    func setDatabase()
    {
        /**
         * 创建数据库
         */
        FLDatabaseManager.shared.setup()
        
        /**
         *  保存用户信息
         */
        saveUserInfo()
        
        /*
         * 创建保存音频的文件夹
         */
        createFolderInDocumentsDirectoryIfNeeded(folderName: getRecordPath)
        
        return
        
        let folderName = "chat_Record_\(UserDefaults.standard.object(forKey: "USERID") ?? "0")"

        let fileName = "example" // 不需要加.txt扩展名，因为我们在appendingPathComponent中添加了

        let content = "Hello, this is a test text file in MyNewFolder."
        if createFolderAndTextFile(folderName: folderName, fileName: fileName, content: content) {
            print("Text file created and written to in MyNewFolder.")
        } else {
            print("Failed to create text file in MyNewFolder.")
        }
    }
    
    func createFolderAndTextFile(folderName: String, fileName: String, content: String) -> Bool {

        // 获取 Documents 目录的 URL
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }

        // 构建 MyNewFolder 文件夹的 URL
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        // 检查文件夹是否存在，如果不存在则创建它
        do {
            try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            // 如果文件夹已经存在，这个错误会被捕获，但我们可以忽略它
        }

        // 构建 .txt 文件的 URL
        let fileURL = folderURL.appendingPathComponent("\(fileName).txt")
        // 写入内容到文件
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File created and written to successfully at path: \(fileURL)")
            return true
        } catch {
            print("Failed to write to file: \(error.localizedDescription)")
            return false
        }
    }
        
    
    func test1()
    {
        
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

