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

/**
 * 数据库相关
 */
let getDatabasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/" + "chat_\(UserDefaults.standard.object(forKey: "USERID") ?? "0").db"


