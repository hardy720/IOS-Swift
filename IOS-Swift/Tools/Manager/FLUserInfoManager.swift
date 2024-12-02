//
//  FLUserInfoManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/21.
//

import Foundation
import CryptoKit

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
    
    func saveSecretKey()
    {
        let key = SymmetricKey(size: .bits256)
        // 使用 withUnsafeBytes 方法访问 SymmetricKey 的原始数据
        let keyData: Data = key.withUnsafeBytes { Data($0) }
        // 将原始数据转换为 Base64 编码的字符串
        let keyBase64 = keyData.base64EncodedString()
        
        let defaultStand = UserDefaults.standard
        defaultStand.setValue(keyBase64, forKey: "secret_key")
        defaultStand.synchronize()
    }
    
    func getSecretKey() -> String
    {
        let defaultStand = UserDefaults.standard
        return defaultStand.object(forKey: "secret_key") as! String
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
        defaultStand.removeObject(forKey: "secret_key")
        defaultStand.synchronize()
    }
}

// MARK: - 测试账号管理 -
extension FLUserInfoManager
{
    func getTestData() -> FLUserModel {
        let testUser = FLUserModel.init()
        testUser.id = "100"
        testUser.userName = "TestUser"
        testUser.avatar = "https://img1.baidu.com/it/u=1071314572,2676229994&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500"
        testUser.passWord = "123456"
        return testUser
    }
    
    func isTestAccount() -> Bool
    {
        let defaultStand = UserDefaults.standard
        return defaultStand.bool(forKey: "IsTestAccount")
    }
    
    func setTestAccount(isTest : Bool)
    {
        let defaultStand = UserDefaults.standard
        defaultStand.set(isTest, forKey: "IsTestAccount")
    }
}
