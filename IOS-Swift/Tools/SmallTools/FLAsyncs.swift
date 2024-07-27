//
//  FLAsyncs.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/20.
//

import Foundation

// 事件闭包
public typealias FLTask = () -> Void

// MARK: - 延迟事件
public struct FLAsyncs {
    // MARK: 1.1、异步做一些任务
    /// 异步做一些任务
    /// - Parameter FLTask: 任务
    @discardableResult
    public static func async(_ FLTask: @escaping FLTask) -> DispatchWorkItem {
        return _asyncDelay(0, FLTask)
    }
    
    // MARK: 1.2、异步做任务后回到主线程做任务
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - FLTask: 异步任务
    ///   - mainFLTask: 主线程任务
    @discardableResult
    public static func async(_ FLTask: @escaping FLTask,
                             _ mainFLTask: @escaping FLTask) -> DispatchWorkItem{
        return _asyncDelay(0, FLTask, mainFLTask)
    }
    
    // MARK: 1.3、异步延迟(子线程执行任务)
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter FLTask: 延迟的block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ FLTask: @escaping FLTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, FLTask)
    }
    
    // MARK: 1.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter FLTask: 延迟的block
    /// - Parameter mainFLTask: 延迟的主线程block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ FLTask: @escaping FLTask,
                                  _ mainFLTask: @escaping FLTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, FLTask, mainFLTask)
    }
}

// MARK: - 私有的方法
extension FLAsyncs {
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - FLTask: 任务
    ///   - mainFLTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                        _ FLTask: @escaping FLTask,
                                        _ mainFLTask: FLTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: FLTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainFLTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
