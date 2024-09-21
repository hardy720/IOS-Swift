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
let getDatabasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/" + "chat_\(UserDefaults.standard.object(forKey: "USERID") ?? "0").db"

func saveUserInfo()
{
    UserDefaults.standard.set("https://gips0.baidu.com/it/u=4249018170,539979145&fm=3039&app=3039&f=JPEG?w=1024&h=1024", forKey: User_My_Avatar)
    UserDefaults.standard.set("擎天柱", forKey: User_My_NickName)
}

func getUserAvatar() -> String
{
    return UserDefaults.standard.object(forKey: User_My_Avatar) as? String ?? ""
}

func getUserNickName() -> String
{
    return UserDefaults.standard.object(forKey: User_My_NickName) as? String ?? ""
}

