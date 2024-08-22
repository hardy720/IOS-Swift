//
//  Singleton.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import Foundation


class Singleton 
{
    // 1. 私有化构造函数，防止外部代码实例化
    private init() {}
      
    // 2. 创建一个静态实例变量
    static let shared = Singleton()
      
    // 示例功能，比如返回一个字符串
    func getMessage() -> String 
    {
        return "Hello from Singleton!"
    }
}
