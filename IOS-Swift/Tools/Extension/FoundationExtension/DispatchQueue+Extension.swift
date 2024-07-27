//
//  DispatchQueue+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/20.
//

import Foundation

extension DispatchQueue: FLPOPCompatible {}

// MARK: - 一、基本的扩展
public extension FLPop where Base == DispatchQueue {
    private static var _onceTracker = [String]()
    // MARK: 1.1、函数只被执行一次
    /// 函数只被执行一次
    /// - Parameters:
    ///   - token: 函数标识
    ///   - block: 执行的闭包
    /// - Returns: 一次性函数
    static func once(token: String, block: () -> ()) {
        if _onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        _onceTracker.append(token)
        block()
    }
}
