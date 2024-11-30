//
//  FLHead.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

class FLHead: NSObject 
{

}

// MARK: - 布局相关 -
func screenW() -> CGFloat
{
    return UIScreen.main.bounds.size.width
}

func screenH() -> CGFloat
{
    return UIScreen.main.bounds.size.height
}

public let fNavigaH = 44 + fStatusH
public let fStatusH = fWindowSafeAreaInset().top
public let fWindowSafeAreaInset = 
{ 
    () -> UIEdgeInsets in
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        insets = getKeyWindow().safeAreaInsets
    }
    return insets
}

// 聊天页面自定义键盘宽度和高度
let Chat_Cell_Text_Width = screenW() - 200
let Chat_Custom_Keyboard_Height : CGFloat = 70
let Chat_Custom_Keyboard_Input_Margin : CGFloat = 50
let Chat_Custom_Keyboard_AddView_Height : CGFloat = 100
let Chat_Cell_Audio_Max_Width = screenW() / 2


// 根据录音长度计算cell宽度
func calculateWidth(index: Int, screenWidth: CGFloat) -> CGFloat
{
    // 确保index在有效范围内
    let safeIndex = max(1, min(index, 60))
    // 计算从1到60的跨度
    let range = 60 - 1
    // 计算当前index占整个范围的比例
    let proportion = CGFloat(safeIndex - 1) / CGFloat(range)
    // 根据比例计算宽度
    // 最小宽度60，最大宽度屏幕宽度，根据比例插值
    let width = 60 + (screenWidth - 50) * proportion
    return width
}

// MARK: - 视图相关 -
public func getKeyWindow() -> UIWindow
{
    var keyWindow: UIWindow? = nil
    if #available(iOS 13.0, *) {
        keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .last?.windows
            .last
    } else {
        keyWindow = UIApplication.shared.keyWindow
    }
    return keyWindow!
}

// MARK: - 数据库相关 -
// 获取沙盒document路径
func getSandbox_document() -> URL?
{
    guard let documentsUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
        FLPrint("Failed to find documents directory")
        return nil
    }
    return documentsUrl
}

var getDatabasePath: String?
{
    guard let documentsURL = getSandbox_document(), let userID = UserDefaults.standard.object(forKey: Chat_User_Id) as? String else {
        FLPrint("Failed to get document directory or user ID")
        return nil
    }
    let dbName = "chat_\(userID).db"
    return documentsURL.appendingPathComponent(dbName).path
}

let getRecordPath = "chat_Record_\(UserDefaults.standard.object(forKey: "USERID") ?? "0")"
let getImgPath = "chat_Img_\(UserDefaults.standard.object(forKey: "USERID") ?? "0")"

func createFolderInDocumentsDirectoryIfNeeded(folderName: String)
{
    // 构造新文件夹的URL
    guard let documentsURL = getSandbox_document() else {
        return
    }
    let folderURL = documentsURL.appendingPathComponent(folderName)
    // 使用FileManager检查文件夹是否存在
    var isDir: ObjCBool = false
    if FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir) && isDir.boolValue {
        // 文件夹已经存在
        FLPrint("Folder already exists at path: \(folderURL.path)")
    } else {
        // 文件夹不存在，创建它
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            FLPrint("Folder created successfully at path: \(folderURL.path)")
            // 构建 .txt 文件的 URL
            let fileURL = folderURL.appendingPathComponent("record.txt")
            let content = "this is record"
            // 写入内容到文件
            do {
                try content.write(to: fileURL, atomically: true, encoding: .utf8)
                FLPrint("File created and written to successfully at path: \(fileURL)")
            } catch {
                FLPrint("Failed to write to file: \(error.localizedDescription)")
            }
        } catch let error {
            // 处理创建文件夹时可能发生的错误
            FLPrint("Failed to create folder with error: \(error.localizedDescription)")
        }
    }
}

// 获取随机的录音
func getRandomFilePathInFolder(folderName: String = "chat_Record_\(UserDefaults.standard.object(forKey: "USERID") ?? "0")") -> String?
{
    // 获取Documents目录的URL
    guard let documentsUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
        FLPrint("Failed to find documents directory")
        return nil
    }
      
    // 构建目标文件夹的URL
    let folderUrl = documentsUrl.appendingPathComponent(folderName)
      
    // 检查目标文件夹是否存在
    guard FileManager.default.fileExists(atPath: folderUrl.path) else {
        FLPrint("Folder does not exist: \(folderUrl.path)")
        return nil
    }
      
    // 获取文件夹内所有文件的URL
    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
          
        // 确保文件夹中有文件
        guard !directoryContents.isEmpty else {
            FLPrint("Folder is empty: \(folderUrl.path)")
            return nil
        }
          
        // 随机选择一个文件的URL
        let randomIndex = Int.random(in: 0..<directoryContents.count)
        let fileUrl = directoryContents[randomIndex]
          
        // 将URL转换为路径字符串// fileUrl为路径和文件名称
        // 仅仅返回名称。
        let fileName = fileUrl.path
        return fileName.components(separatedBy: "/").last
    } catch {
        FLPrint("Failed to list directory contents: \(error.localizedDescription)")
        return nil
    }
}

