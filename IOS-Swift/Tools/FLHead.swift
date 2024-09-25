//
//  FLHead.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

class FLHead: NSObject {

}

/**
 * 位置相关
 */
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

/**
 * 视图相关
 */
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

/**
 * 数据库相关
 */
let getSandbox_document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
let getDatabasePath = getSandbox_document + "/" + "chat_\(UserDefaults.standard.object(forKey: "USERID") ?? "0").db"
let getRecordPath = getSandbox_document + "/" + "chat_Record_\(UserDefaults.standard.object(forKey: "USERID") ?? "0")"


func createFolderInDocumentsDirectoryIfNeeded(folderName: String)
{
    // 获取文档目录的URL
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // 构造新文件夹的URL
    let folderURL = documentsDirectoryURL.appendingPathComponent(folderName)
    // 使用FileManager检查文件夹是否存在
    var isDir: ObjCBool = false
    if FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir) && isDir.boolValue {
        // 文件夹已经存在
        print("Folder already exists at path: \(folderURL.path)")
    } else {
        // 文件夹不存在，创建它
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            print("Folder created successfully at path: \(folderURL.path)")
        } catch let error {
            // 处理创建文件夹时可能发生的错误
            print("Failed to create folder with error: \(error.localizedDescription)")
        }
    }
}


func saveUserInfo()
{
    UserDefaults.standard.set("https://gips0.baidu.com/it/u=4249018170,539979145&fm=3039&app=3039&f=JPEG?w=1024&h=1024", forKey: Chat_User_Avatar)
    UserDefaults.standard.set("擎天柱", forKey: Chat_User_NickName)
}

func getUserAvatar() -> String
{
    return UserDefaults.standard.object(forKey: Chat_User_Avatar) as? String ?? ""
}

func getUserNickName() -> String
{
    return UserDefaults.standard.object(forKey: Chat_User_NickName) as? String ?? ""
}

