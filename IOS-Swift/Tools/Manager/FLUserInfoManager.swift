//
//  FLUserInfoManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/21.
//

import Foundation

class FLUserInfoManager
{
    // 单例实例
    static let shared = FLUserInfoManager()
    
    // 私有初始化器，防止外部创建实例
    private init() {}
    
    func isLogin() -> Bool 
    {
        let defaultStand = UserDefaults.standard
        let token = defaultStand.string(forKey: "token") ?? ""
        if (token.fl.isStringBlank()) {
            return false
        }
        return true
    }
    
    func logOut() 
    {
        self.removeToken()
        self.clearUserInfo()
    }
    
    func getUserInfo() -> FLUserModel
    {
        let defaultStand = UserDefaults.standard
        let userInfo = FLUserModel.init()
        userInfo.id = defaultStand.object(forKey: Chat_User_Id) as! String
        userInfo.userName = defaultStand.object(forKey: Chat_User_NickName) as! String
        userInfo.passWord = defaultStand.object(forKey: Chat_User_PassWord) as! String
        userInfo.avatar = defaultStand.object(forKey: Chat_User_Avatar) as! String
        return userInfo
    }
    
    func saveUserInfo(userM : FLUserModel)
    {
        let defaultStand = UserDefaults.standard
        defaultStand.setValue(userM.id, forKey: Chat_User_Id)
        defaultStand.setValue(userM.passWord, forKey: Chat_User_PassWord)
        defaultStand.setValue(userM.userName, forKey: Chat_User_NickName)
        defaultStand.setValue(userM.avatar, forKey: Chat_User_Avatar)
        defaultStand.synchronize()
    }
    
    func saveToken(token : String)
    {
        let defaultStand = UserDefaults.standard
        defaultStand.setValue(token, forKey: "token")
        defaultStand.synchronize()
    }
    
    func removeToken()
    {
        let defaultStand = UserDefaults.standard
        defaultStand.removeObject(forKey: "token")
        defaultStand.synchronize()
    }
    
    func clearUserInfo() 
    {
        let defaultStand = UserDefaults.standard
        defaultStand.removeObject(forKey: "userId")
        defaultStand.removeObject(forKey: "createtime")
        defaultStand.removeObject(forKey: "passWord")
        defaultStand.removeObject(forKey: "userName")
        defaultStand.removeObject(forKey: "avatar")
        defaultStand.synchronize()
    }
}
