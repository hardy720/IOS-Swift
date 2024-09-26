//
//  FLAudioRecorder.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/25.
//

import Foundation
import AVFAudio
import AVFoundation

@objc public protocol FLSoundRecorderDelegate: AnyObject
{
    @objc optional func soundRecordFailed() // 录音失败
    @objc optional func soundRecordDidStop() // 录音停止
    @objc optional func soundRecordTooShort() // 录音时间太短（少于1秒）
    @objc optional func soundRecordTimerTicks(second: NSInteger) // 录音过程中，每秒调用一次，返回当前录音时长
}

class FLAudioRecorder: NSObject, AVAudioRecorderDelegate
{
    static let shared = FLAudioRecorder()
    static let maxLength = 60 //录音时长限制60s
    var recordPath: NSString!
    var audioRecorder: AVAudioRecorder!
    var timer: Timer!
    var recordSeconds: NSInteger = 0
    var delegate: FLSoundRecorderDelegate?
    
    //MARK: Public

    /**
    *  开始录音
    *
    *  @param view 展现录音指示框的父视图
    *  @param path 音频文件保存路径
    */
    public func startRecord(recordPath: NSString)
    {
        recordSeconds = 0
        self.recordPath = recordPath
        self.startRecord()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.recordSeconds += 1
            self.delegate?.soundRecordTimerTicks?(second: self.recordSeconds)
            if self.recordSeconds == FLAudioRecorder.maxLength {
                self.stopSoundRecord()
            }
            print("正在录音：\(self.recordSeconds)s")
        }
    }
    
    /**
    *  录音结束
    */
    public func stopSoundRecord()
    {
        if timer != nil {
            timer.invalidate()
        }
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        self.delegate?.soundRecordDidStop?()
        if self.recordSeconds < 1 {
            self.delegate?.soundRecordTooShort?()
        }
    }
    
    //MARK: Private
    /**
     *  开始录音，AVAudioSession配置
     */
    func startRecord()
    {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: URL(string: self.recordPath as String)!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        self.delegate?.soundRecordDidStop?()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
        if timer != nil {
            timer.invalidate()
        }
        self.recordSeconds = 0
        self.delegate?.soundRecordFailed?()
    }
    
    func getAuthorizedStatus() -> Bool
    {
        var isOk = false
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) {
        case .notDetermined:
            FLPrint("尚未请求麦克风访问")
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    // 用户授权了
                    FLPrint("麦克风权限请求成功")
                } else {
                    // 用户拒绝了
                    FLPrint("麦克风权限请求被拒绝")
                }
            }
            
        case .restricted:
            FLPrint("麦克风访问受限或仅在使用时授权")

        case .denied:
            FLPrint("麦克风访问被拒绝")

        case .authorized:
            print("麦克风授权成功")
            isOk = true
        @unknown default:
            fatalError()
        }
        return isOk
    }
}
