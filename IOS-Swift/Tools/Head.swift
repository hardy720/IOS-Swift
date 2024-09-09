//
//  Tools.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

class Head: NSObject {

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
 * 字符串
 */
let Appdelegate_RootVC_Key_Str = "Appdelegate_RootVC"
let Appdelegate_RootVC_Value_A_Str = "A"
let Appdelegate_RootVC_Value_B_Str = "B"

/**
 * 数据库相关
 */
let getDatabasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/" + "chat_\(UserDefaults.standard.object(forKey: "USERID") ?? "0").db"


