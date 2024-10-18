//
//  Int+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/1.
//

import Foundation

let Tag_1000 = 1000


extension Int: FLPOPCompatible {}

// MARK: - 一、基本的扩展方法
public extension FLPop where Base == Int
{
    // MARK: 1.1、取区间内的随机数，如取  0..<10 之间的随机数
    ///  取区间内的随机数，如取  0..<10 之间的随机数
    /// - Parameter within: 0..<10
    /// - Returns: 返回区间内的随机数
    static func random(within: Range<Int>) -> Int {
        let delta = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}
