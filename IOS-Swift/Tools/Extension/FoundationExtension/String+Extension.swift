//
//  String+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import Foundation
import UIKit
import CommonCrypto
import CryptoKit

extension String: FLPOPCompatible {}

/// 字符串取类型的长度
public enum StringTypeLength {
    /// Unicode字符个数
    case count
    /// utf8
    case utf8
    /// utf16获取长度对应NSString的.length方法
    case utf16
    /// unicodeScalars
    case unicodeScalars
    /// utf8编码通过字节判断长度
    case lengthOfBytesUtf8
    /// 英文 = 1，数字 = 1，汉语 = 2
    case customCountOfChars
}

// MARK: - 五、字符串的转换
public extension FLPop where Base: ExpressibleByStringLiteral {
    
    // MARK: 5.1、字符串 转 CGFloat
    /// 字符串 转 Float
    /// - Returns: CGFloat
    func toCGFloat() -> CGFloat? {
        if let doubleValue = Double(base as! String) {
            return CGFloat(doubleValue)
        }
        return nil
    }
    
    // MARK: 5.2、字符串转 Bool
    /// 字符串转 Bool
    /// - Returns: Bool
    func toBool() -> Bool? {
        switch (base as! String).lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    
    // MARK: 5.3、字符串转 Int
    /// 字符串转 Int
    /// - Returns: Int
    func toInt() -> Int? {
        guard let doubleValue = Double(base as! String) else { return nil }
        return Int(doubleValue)
    }
    
    // MARK: 5.4、字符串转 Double
    /// 字符串转 Double
    /// - Returns: Double
    func toDouble() -> Double? {
        return Double(base as! String)
    }
    
    // MARK: 5.7、字符串转 NSString
    /// 字符串转 NSString
    var toNSString: NSString {
        return (base as! String) as NSString
    }
}

// MARK: - 六、字符串UI的处理
extension FLPop where Base: ExpressibleByStringLiteral {
    
    // MARK: 6.1、对字符串(多行)指定出字体大小和最大的 Size，获取 (Size)
    /// 对字符串(多行)指定出字体大小和最大的 Size，获取展示的 Size
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串的最大宽和高
    /// - Returns: 按照 font 和 Size 的字符的Size
    public func rectSize(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        /**
         usesLineFragmentOrigin: 整个文本将以每行组成的矩形为单位计算整个文本的尺寸
         usesFontLeading:
         usesDeviceMetrics:
         @available(iOS 6.0, *)
         truncatesLastVisibleLine:
         */
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = (base as! String).boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
}

// MARK: - 十一、字符串截取的操作
extension FLPop where Base: ExpressibleByStringLiteral {
    
    // MARK: 11.13、字符串长度不足前面补0
    /// 字符串长度不足前面补0
    public func prefixAddZero(_ length: Int) -> String {
        return insufficientLengthAdZero(length)
    }
    
    // MARK: 11.14、字符串长度不足后面补0
    /// 字符串长度不足后面补0
    public func suffixAddZero(_ length: Int) -> String {
        return insufficientLengthAdZero(length, isPrefixAddZer: false)
    }
    
    // MARK: 字符串长度不足补0
    /// 字符串长度不足后面补0
    private func insufficientLengthAdZero(_ length: Int, isPrefixAddZer: Bool = true) -> String {
        let string = base as! String
        guard string.count < length else {
            return string
        }
        let zero = String(repeating: "0", count: length - string.count)
        return isPrefixAddZer ? (zero + string) : (string + zero)
    }
}
