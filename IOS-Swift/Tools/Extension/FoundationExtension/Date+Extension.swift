//
//  Date+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/10.
//

import Foundation


extension Date: FLPOPCompatible {}

/// 时间戳的类型
public enum FLTimestampType: Int {
    /// 秒
    case second
    /// 毫秒
    case millisecond
}

// MARK: - 一、Date 基本的扩展
public extension FLPop where Base == Date {
    // MARK: 1.1、获取当前 秒级 时间戳 - 10 位
    /// 获取当前 秒级 时间戳 - 10 位
    static var secondStamp : String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    // MARK: 1.2、获取当前 毫秒级 时间戳 - 13 位
    /// 获取当前 毫秒级 时间戳 - 13 位
    static var milliStamp : String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    // MARK: 1.3、从 Date 获取年份
    /// 从 Date 获取年份
    var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self.base)
    }
    
    // MARK: 1.4、从 Date 获取月份
    /// 从 Date 获取年份
    var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self.base)
    }
    
    // MARK: 1.5、从 Date 获取 日
    /// 从 Date 获取 日
    var day: Int {
        return Calendar.current.component(.day, from: self.base)
    }
    
    // MARK: 1.6、从 Date 获取 小时
    /// 从 Date 获取 日
    var hour: Int {
        return Calendar.current.component(.hour, from: self.base)
    }
    
    // MARK: 1.7、从 Date 获取 分钟
    /// 从 Date 获取 分钟
    var minute: Int {
        return Calendar.current.component(.minute, from: self.base)
    }
    
    // MARK: 1.8、从 Date 获取 秒
    /// 从 Date 获取 秒
    var second: Int {
        return Calendar.current.component(.second, from: self.base)
    }
    
    // MARK: 1.9、从 Date 获取 毫秒
    /// 从 Date 获取 毫秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self.base)
    }
    // MARK: 1.10、从日期获取 星期(英文)
    /// 从日期获取 星期
    var weekday: String {
        fl_formatter.dateFormat = "EEEE"
        return fl_formatter.string(from: self.base)
    }
    
    // MARK: 1.11、从日期获取 星期(中文)
    var weekdayStringFromDate: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self.base as Date)
        return  weekdays[theComponents.weekday! - 1]
    }
    
    // MARK: 1.12、从日期获取 月(英文)
    /// 从日期获取 月(英文)
    var monthAsString: String {
        fl_formatter.dateFormat = "MM"
        return fl_formatter.string(from: self.base)
    }
    
    // MARK: 1.13、获取当前的时间 Date
    /// 获取当前的时间 Date
    static var currentDate : Date {
        return Base()
    }
    
    // MARK: 1.13、获取当前的时间字符串
    /// 获取当前的时间字符串,精确到秒
    static func currentDate_ss() -> String {
        fl_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fl_formatter.string(from: currentDate)
    }
    
    // MARK: 1.14、获取当前的时间字符串
    /// 获取当前的时间字符串,精确到毫秒
    static func currentDate_SSS() -> String {
        fl_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return fl_formatter.string(from: currentDate)
    }
}

//MARK: - 二、时间格式的转换
// MARK: 时间条的显示格式
public enum JKTimeBarType {
    // 默认格式，如 9秒：09，66秒：01：06，
    case normal
    case second
    case minute
    case hour
}

public extension FLPop where Base == Date {
    
    // MARK: 2.1、时间戳(支持10位和13位)按照对应的格式 转化为 对应时间的字符串
    /// 时间戳(支持10位和13位)按照对应的格式 转化为 对应时间的字符串 如：1603849053 按照 "yyyy-MM-dd HH:mm:ss" 转化后为：2020-10-28 09:37:33
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - format: 格式
    /// - Returns: 对应时间的字符串
    static func timestampToFormatterTimeString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // 时间戳转为Date
        let date = timestampToFormatterDate(timestamp: timestamp)
        // let dateFormatter = DateFormatter()
        // 设置 dateFormat
        fl_formatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return fl_formatter.string(from: date)
    }
    
    // MARK: 2.2、时间戳(支持 10 位 和 13 位) 转 Date
    /// 时间戳(支持 10 位 和 13 位) 转 Date
    /// - Parameter timestamp: 时间戳
    /// - Returns: 返回 Date
    static func timestampToFormatterDate(timestamp: String) -> Date {
        guard timestamp.count == 10 ||  timestamp.count == 13 else {
            #if DEBUG
            fatalError("时间戳位数不是 10 也不是 13")
            #else
            return Date()
            #endif
        }
        guard let timestampInt = timestamp.fl.toInt() else {
            #if DEBUG
            fatalError("时间戳位有问题")
            #else
            return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }
    
    /// 根据本地时区转换
    private static func getNowDateFromatAnDate(_ anyDate: Date?) -> Date? {
        // 设置源日期时区
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        // 或GMT
        // 设置转换后的目标日期时区
        let destinationTimeZone = NSTimeZone.local as NSTimeZone
        // 得到源日期与世界标准时间的偏移量
        var sourceGMTOffset: Int? = nil
        if let aDate = anyDate {
            sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
        }
        // 目标日期与本地时区的偏移量
        var destinationGMTOffset: Int? = nil
        if let aDate = anyDate {
            destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
        }
        // 得到时间偏移量的差值
        let interval = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
        // 转为现在时间
        var destinationDateNow: Date? = nil
        if let aDate = anyDate {
            destinationDateNow = Date(timeInterval: interval, since: aDate)
        }
        return destinationDateNow
    }
    
    // MARK: 2.3、Date 转换为相应格式的时间字符串，如 Date 转为 2020-10-28
    /// Date 转换为相应格式的字符串，如 Date 转为 2020-10-28
    /// - Parameter format: 转换的格式
    /// - Returns: 返回具体的字符串
    func toformatterTimeString(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // let dateFormatter = DateFormatter()
        fl_formatter.timeZone = TimeZone.autoupdatingCurrent
        fl_formatter.dateFormat = formatter
        return fl_formatter.string(from: self.base)
    }
    
    // MARK: 2.4、带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// 带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString: 时间字符串，如：2020-10-26 16:52:41
    ///   - formatter: 时间格式，如：yyyy-MM-dd HH:mm:ss
    ///   - timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 返回转化后的时间戳
    static func formatterTimeStringToTimestamp(timesString: String, formatter: String, timestampType: FLTimestampType = .second) -> String {
        fl_formatter.dateFormat = formatter
        fl_formatter.locale = NSLocale.system
        guard let date = fl_formatter.date(from: timesString) else {
            #if DEBUG
            fatalError("日期格式不匹配")
            #else
            return ""
            #endif
        }
        if timestampType == .second {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int((date.timeIntervalSince1970) * 1000))"
    }
    
    // MARK: 2.5、带格式的时间转 Date
    /// 带格式的时间转 Date
    /// - Parameters:
    ///   - timesString: 时间字符串
    ///   - formatter: 格式
    /// - Returns: 返回 Date
    static func formatterTimeStringToDate(timesString: String, formatter: String) -> Date {
        fl_formatter.dateFormat = formatter
        fl_formatter.locale = NSLocale.system
        guard let date = fl_formatter.date(from: timesString) else {
            #if DEBUG
            fatalError("时间有问题")
            #else
            return Date()
            #endif
        }
        /*
        guard let resultDate = getNowDateFromatAnDate(date) else {
            return Date()
        }
        */
        return date
    }
    
    // MARK: 2.6、秒转换成播放时间条的格式
    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - secounds: 秒数
    ///   - type: 格式类型
    /// - Returns: 返回时间条
    static func getFormatPlayTime(seconds: Int, type: JKTimeBarType = .normal) -> String {
        if seconds <= 0{
            return "00:00"
        }
        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d:%02d", minute, second)
        }
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        if type == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
    
    // MARK: 2.7、Date 转 时间戳
    /// Date 转 时间戳
    /// - Parameter timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 时间戳
    func dateToTimeStamp(timestampType: FLTimestampType = .second) -> String {
        // 10位数时间戳 和 13位数时间戳
        let interval = timestampType == .second ? CLongLong(Int(self.base.timeIntervalSince1970)) : CLongLong(round(self.base.timeIntervalSince1970 * 1000))
        return "\(interval)"
    }
    
    // 转成当前时区的日期
    func dateFromGMT() -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: self.base))
        return self.base.addingTimeInterval(secondFromGMT)
    }
}
