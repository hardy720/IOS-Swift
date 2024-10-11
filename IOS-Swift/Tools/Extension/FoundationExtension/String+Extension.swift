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

/**
 * 字符串
 */
let Appdelegate_RootVC_Key_Str = "Appdelegate_RootVC"
let Appdelegate_RootVC_Value_A_Str = "A"
let Appdelegate_RootVC_Value_B_Str = "B"
let Appdelegate_HomeVC_SwitchStatus = "切换状态"
let Chat_ChatHome_NewChat = "新建聊天"
let Chat_User_Avatar = "User_MyAvatar"
let Chat_User_NickName = "User_MyNickName"
let Chat_User_Id = "USERID"
let Chat_Keyboard_Hold_Speak = "按住 说话"
let Chat_Keyboard_Release_End = "松开 结束"
let Chat_Keyboard_Cancel_Record_Alert = "手指上划,取消发送"
let Chat_Keyboard_Cancel_Release_Record_Alert = "手指松开,取消发送"

let Chat_Keyboart_Record_Check_Permission = "请检查麦克风授权"
let Test_Test_IsOpen = "Test_Test_IsOpen"
let Test_Test_OpenTest = "Open Test"
let Test_Test_CloseTest = "Close Test"


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


// MARK: 一、获取任意字符串
public extension FLPop where Base: ExpressibleByStringLiteral
{
    static func getDynamicRandomImageUrlStr() -> String?
    {
        let imgArr = [
            "https://img.soogif.com/85hz5bGr8OwnL9HFgN8gqXaBsBGEdkjQ.gif",
            "https://n.sinaimg.cn/translate/w500h281/20180201/sWyj-fyrcsrw3696759.gif",
            "https://5b0988e595225.cdn.sohucs.com/images/20200123/f3c7bf0bb2db4e0abbbb22b2d64d0bd2.gif",
            "https://hbimg.b0.upaiyun.com/7c3f2fc54404bf90fff8f8a6735961dce7bfe0a6f1d00-1MimFm_fw658",
            "https://hbimg.b0.upaiyun.com/16da81d7fed58949ac2038d68568d52da0d7a0ad704b2-GRYNUZ_fw658",
            "https://hbimg.b0.upaiyun.com/b577de268f35b144ad767db43d04abadc2efc0f3779a3-jLEKvg_fw658"
        ]
        return imgArr[Int.fl.random(within: 0..<imgArr.count)]
    }
    
    static func getRandomImageUrlStr() -> String?
    {
        let imgArr = [
            "https://img0.baidu.com/it/u=98092773,2720963228&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1779",
            "http://img1.baidu.com/it/u=464151090,2377346627&fm=253&app=138&f=JPEG?w=800&h=1779",
            "http://img0.baidu.com/it/u=492863294,3968106839&fm=253&app=138&f=JPEG?w=800&h=1779",
            "http://img0.baidu.com/it/u=945706159,627732918&fm=253&app=138&f=JPEG?w=800&h=1779",
            "http://img1.baidu.com/it/u=4224016410,4222420533&fm=253&app=138&f=JPEG?w=800&h=1779",
            "https://pic.rmb.bdstatic.com/bjh/4447a8251696d012b8af01aea8b785a7.jpeg",
            "https://b.bdstatic.com/8bac78e3fc52ca37e4ad7f53612e5c74.jpeg",
            "https://pic.rmb.bdstatic.com/5c30a5690fbbad7e119b1b8b87489490.jpeg@s_0,w_1242",
            "https://n.sinaimg.cn/sinakd10119/136/w1080h1456/20211017/47a6-14e74a851b634ceeedacb27d3839149a.jpg",
            "http://img2.baidu.com/it/u=65164849,141121788&fm=253&app=138&f=JPEG?w=800&h=1779",
            "http://img1.baidu.com/it/u=3094600604,3514337114&fm=253&app=138&f=JPEG?w=800&h=1779",
            "https://img0.baidu.com/it/u=3975361382,3483567849&fm=253&fmt=auto&app=138&f=JPEG?w=340&h=470",
            "https://p26.toutiaoimg.com/large/pgc-image/04c8ed18081a4736a13aad32a4a3444c.jpg",
            "https://n.sinaimg.cn/sinakd20109/528/w1080h1848/20230520/5b6c-6d3c6583c4fc8d2c5c7d4035b2044d25.jpg",
            "https://ww4.sinaimg.cn/mw690/007bnhD5ly1h9blr0i05lj318s0u0gvc.jpg",
            "https://img1.baidu.com/it/u=2549767271,3784592196&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500",
            "https://hbimg.huabanimg.com/3835f142855b1bfead73398abe14b3b1607bfcff121da0-ucA9C6_fw658",
            "https://dingyue.ws.126.net/8Ikj20AB13vPBw8Gd9C9lmJflIQiv4KfV2UV5I4XgBEFQ1547116825220compressflag.jpeg",
            "https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2023%2F1108%2F403f1760j00s3spz5001ed000nk00kap.jpg&thumbnail=660x2147483647&quality=80&type=jpg",
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F08a5ba5a-d106-4e49-b527-b2d4c0e0fcb6%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1725520016&t=7eb7b24df09bc37d4ad3bd0b5bb18954",
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F7c3aa629-4c55-4d07-8bca-0717e5d7fda4%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1725520016&t=00d46ae4550e7c13d3f83cb139dad2c6",
            "http://img1.error"
        ]
        return imgArr[Int.fl.random(within: 0..<imgArr.count)]
    }
    
    // 获取随机字符串
    static func shuffleString(str: String = "晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。,晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。晨曦微露，轻纱般的薄雾缭绕于山峦之间，宛如一幅淡雅的水墨画。阳光透过云层，斑驳陆离地洒在蜿蜒的小径上，金色的光辉与葱郁的林木交织，生机勃勃。溪水潺潺，清澈见底，细石间偶有鱼儿轻摆尾鳍，漾起层层细腻的涟漪。远处，群山如黛，层峦叠嶂，云雾缭绕其巅，似仙境般缥缈。春风拂面，带着泥土与花香的清新，让人心旷神怡。桃花、杏花竞相绽放，粉白相间，点缀在翠绿之中，宛如羞涩的少女，含笑迎风。鸟鸣声声，清脆悦耳，它们或在枝头嬉戏，或在空中翱翔，自由而欢快。此情此景，美不胜收，仿佛整个世界都沉浸在一片宁静与和谐之中，让人忘却尘嚣，沉醉不已。") -> String
    {
        // 将字符串转换为字符数组
        var characters = Array(str)
        // 使用Fisher-Yates洗牌算法打乱字符顺序
        for i in 0..<characters.count-1 {
            let j = Int.random(in: i..<characters.count)
            // 交换两个位置的字符
            (characters[i], characters[j]) = (characters[j], characters[i])
        }
        let random = [Int.fl.random(within: 1..<characters.count)]
        return String(String(characters).prefix(random[0]))
    }
    
    //判断字符串是否为空
    func isStringBlank () -> Bool
    {
        let string = base as! String
        return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - 五、字符串的转换
public extension FLPop where Base: ExpressibleByStringLiteral 
{
    
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

