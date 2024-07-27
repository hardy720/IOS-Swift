//
//  FLPrint.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/10.
//

import Foundation
import Toast_Swift

// MARK: - 自定义打印
/** 自定义打印
 * - Parameter msg: 打印的内容
 * - Parameter file: 文件路径
 * - Parameter line: 打印内容所在的 行
 * - Parameter column: 打印内容所在的 列
 * - Parameter fn: 打印内容的函数名
 */
public func FLPrint(_ msg: Any...,
               isWriteLog: Bool = true,
                     file: NSString = #file,
                     line: Int = #line,
                   column: Int = #column,
                       fn: String = #function) {
    #if DEBUG
    var msgStr = ""
    for element in msg {
        msgStr += "\(element)"
    }
    let currentDate = Date.fl.currentDate_SSS()
    let prefix = "\(currentDate): \(file.lastPathComponent) Line:\(line) Col:\(column) msg:\(msgStr)"
    print(prefix)
    
    if let navController = NavigationControllerManager.shared.getCurrentNavigationController() {
        DispatchQueue.main.async {
            navController.view.makeToast(prefix)
        }
    }
    guard isWriteLog else {
        return
    }
    // 将内容同步写到文件中去（Caches文件夹下）
    let cachePath = FileManager.fl.CachesDirectory()
    let logURL = cachePath + "/log.txt"
    appendText(fileURL: URL(string: logURL)!, string: "\(prefix)", currentDate: "\(currentDate)")
    #endif
}

// 在文件末尾追加新内容
private func appendText(fileURL: URL, string: String, currentDate: String) {
    do {
        // 如果文件不存在则新建一个
        FileManager.fl.createFile(filePath: fileURL.path)
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        let stringToWrite = "\n" + string
        // 找到末尾位置并添加
        fileHandle.seekToEndOfFile()
        fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
    } catch let error as NSError {
        print("failed to append: \(error)")
    }
}

