//
//  LiquidUILog.swift
//  LiquidUI
//
//  Created by Hardy on 2026/5/29.
//

import Foundation
import UIKit

private let LOG_FILE_NAME_NEW = "Guixt_Gala.log"
private let LOG_FILE_NAME_OLD = "Guixt_Gala.log_old"
private let LOG_FILE_SIZE_LIMIT = 2 * 1024 * 1024
private let LOG_SAVE_THREAD_NAME = "com.shengaike.liquidUI.logQueue"

final class LiquidUILog: NSObject, @unchecked Sendable {

    // MARK: - Properties (readonly)
    private(set) var m_logFileName: String
    private(set) var m_oldLogFileName: String
    private(set) var m_appName: String
    private static let logQueue = DispatchQueue(label: LOG_SAVE_THREAD_NAME)

    // MARK: - Singleton
    static let instance: LiquidUILog = {
        let instance = LiquidUILog()
        instance.configure()
        return instance
    }()

    private override init() {
        self.m_logFileName = ""
        self.m_oldLogFileName = ""
        self.m_appName = ""
        super.init()
    }

    override func copy() -> Any { return self }
    override func mutableCopy() -> Any { return self }

    // MARK: - Configuration
    private func configure() {
        m_appName = "Guixt_Gala"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first ?? ""
        m_logFileName = (documentsDirectory as NSString).appendingPathComponent(LOG_FILE_NAME_NEW)
        m_oldLogFileName = (documentsDirectory as NSString).appendingPathComponent(LOG_FILE_NAME_OLD)
    }

    // MARK: - Log To File
    func LogToFile(_ log: String) {
//        #if DEBUG
//        print(log)
//        #else
//        if UserDefaults.standard.bool(forKey: "logToFileFlag") ||
//           UserDefaults.standard.bool(forKey: "bShouldSendCrashInfo") {
            Self.logQueue.async { [weak self] in
                guard let self = self else { return }
                let dataToWrite = "\n\(log)".data(using: String.Encoding.utf8)
                let fileHandle = FileHandle(forUpdatingAtPath: self.m_logFileName)
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: self.m_logFileName) {
                    if !fileManager.createFile(atPath: self.m_logFileName, contents: nil, attributes: nil) {
                        print("Failed to create file")
                    }
                } else {
                    fileHandle?.seekToEndOfFile()
                }
                if let data = dataToWrite {
                    fileHandle?.write(data)
                }
                fileHandle?.closeFile()

                if self.isFileSizeExceeded(self.m_logFileName, size: LOG_FILE_SIZE_LIMIT) {
                    print("File size over 2MB")
                    self.switchFileFrom(self.m_logFileName, to: self.m_oldLogFileName)
                }
//            }
        }
//        #endif
    }

    private func switchFileFrom(_ sFrom: String, to sTo: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: sTo) {
            do {
                try fileManager.removeItem(atPath: sTo)
                print("File deleted successfully")
            } catch {
                print("File Deletion Failed: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist")
        }

        if fileManager.fileExists(atPath: sFrom) {
            do {
                try fileManager.moveItem(atPath: sFrom, toPath: sTo)
                print("File renamed successfully")
            } catch {
                print("Failed to rename a file. \(error.localizedDescription)")
            }
        } else {
            print("Source file does not exist")
        }
    }

    private func isFileSizeExceeded(_ filePath: String, size sizeLimitInBytes: Int) -> Bool {
        let fileManager = FileManager.default
        guard let attributes = try? fileManager.attributesOfItem(atPath: filePath),
              let fileSizeNumber = attributes[.size] as? NSNumber else {
            return false
        }
        let fileSize = fileSizeNumber.int64Value
        return fileSize > Int64(sizeLimitInBytes)
    }

    // MARK: - Save or Update App Info
    func saveOrUpdateAppInfo() {
        if UserDefaults.standard.bool(forKey: "logToFileFlag") ||
           UserDefaults.standard.bool(forKey: "bShouldSendCrashInfo") {
            let appInfoStart = "/******Liquid UI for iOS******/"
            let appInfoEnd   = "/*****************************/"

            let deviceName = UIDevice.current.name
            let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            let appInfo = """
                \(appInfoStart)
                iOS version:\(UIDevice.current.systemVersion),
                deviceType:\(deviceName),
                appVersion:\(appVersion)
                \(appInfoEnd)

                """

            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: m_logFileName) {
                do {
                    let fileContent = try String(contentsOfFile: m_logFileName, encoding: .utf8)

                    // Use NSString for easy NSRange operations
                    let nsFileContent = fileContent as NSString
                    let nsAppInfo = appInfo as NSString
                    let rangeOfEnd = nsFileContent.range(of: appInfoEnd)

                    if rangeOfEnd.location != NSNotFound {
                        // Update existing app info
                        let rangeToReplace = NSRange(location: 0, length: rangeOfEnd.location + rangeOfEnd.length)
                        let newContent = nsFileContent.replacingCharacters(in: rangeToReplace, with: appInfo)
                        try newContent.write(toFile: m_logFileName, atomically: true, encoding: .utf8)
                        print("Data updated successfully")
                    } else {
                        // Append app info at the beginning
                        let newContent = appInfo + fileContent
                        try newContent.write(toFile: m_logFileName, atomically: true, encoding: .utf8)
                        print("Data saved successfully")
                    }
                } catch {
                    print("Data Save/Update Failure: \(error.localizedDescription)")
                }
            }
        }
    }
}
