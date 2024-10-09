//
//  FLAudioRecorder.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/25.
//

import Foundation
import AVFAudio
import AVFoundation

/**
 * ******* 录音 ******
 */
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
    var recordFileName: NSString!
    var recordFilePath: NSString!
    var audioRecorder: AVAudioRecorder!
    var timer: Timer!
    var recordSeconds: NSInteger = 0
    var delegate: FLSoundRecorderDelegate?
    
    // 声音大小
    private var audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var format: AVAudioFormat?
    private var amplitudeCallback: ((Float) -> Void)?
    
    //MARK: Public

    /**
    *  开始录音
    *
    *  @param view 展现录音指示框的父视图
    *  @param path 音频文件保存路径
    */
    public func startRecord(recordFileName: NSString, pathStr:NSString,amplitudeCallback: @escaping (Float) -> Void)
    {
        recordSeconds = 0
        self.recordFileName = recordFileName
        self.recordFilePath = pathStr
        self.start()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.recordSeconds += 1
            self.delegate?.soundRecordTimerTicks?(second: self.recordSeconds)
            if self.recordSeconds == FLAudioRecorder.maxLength {
                self.stopSoundRecord()
            }
            FLPrint("正在录音：\(self.recordSeconds)s")
        }
        
        // 监听声音大小
        self.amplitudeCallback = amplitudeCallback
        setupAudioEngine()
    }
    
    // MARK: - 结束录音 -
    public func stopSoundRecord()
    {
        if timer != nil {
            timer.invalidate()
        }
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            self.delegate?.soundRecordDidStop?()
            if self.recordSeconds < 1 {
                self.delegate?.soundRecordTooShort?()
            }
        } catch {
            print("Failed to stop soundRecord: \(error)")
        }
    }
    
    // MARK: - 开始录音 -
    func start()
    {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: URL(string: self.recordFileName as String)!, settings: [:])
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
    
    // MARK: - 检查录音权限是否开启 -
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
    
    private func setupAudioEngine()
    {
        // 获取输入节点
       inputNode = audioEngine.inputNode
       // 查询硬件输入格式
        if let hwFormat = inputNode?.inputFormat(forBus: 0) {
           // 根据硬件格式创建 AVAudioFormat 实例
            format = AVAudioFormat(settings: hwFormat.settings)
           // 注意：如果 hwFormat 是非交织的（interleaved: false），并且您确实需要这种格式，
           // 您可能需要手动创建一个新的 AVAudioFormat 实例，因为从 settings 中创建的可能是交织的。
           // 但是，在大多数情况下，使用硬件提供的格式设置应该是足够的。
           // 如果出于某种原因您需要特定的格式（例如，您正在处理特定类型的音频处理算法），

           // 并且该格式与硬件格式不兼容，那么您可能需要在安装 tap 之前进行格式转换。
           // 安装 tap 来捕获音频数据
           inputNode?.installTap(onBus: 0, bufferSize: 1024, format: format!) { [weak self] (buffer, when) in
               guard let strongSelf = self else { return }
               strongSelf.handleAudioBuffer(buffer)
           }
       } else {
           // 处理无法获取硬件输入格式的情况
           print("无法获取硬件输入格式")
       }

       // 启动音频引擎
       do {
           try audioEngine.start()
       } catch {
           print("无法启动音频引擎: \(error)")
       }
    }
    
    private func handleAudioBuffer(_ buffer: AVAudioPCMBuffer)
    {
        let channelData = buffer.floatChannelData?.pointee
        guard let data = channelData, buffer.frameLength > 0 else {
            return
        }
        var maxAmplitude: Float = 0.0
        for frame in 0..<Int(buffer.frameLength) {
            let sample = data[frame]
            let absoluteSample = fabsf(sample)
            if absoluteSample > maxAmplitude {
                maxAmplitude = absoluteSample
            }
        }
        // 使用闭包回调来传递振幅
        amplitudeCallback?(maxAmplitude)
    }
  
    // 确保在不需要时停止音频引擎
    func stop()
    {
        audioEngine.stop()
        inputNode?.removeTap(onBus: 0)
    }
}

/*
 * ****** 监听声音大小 ******
 */
class AudioMonitor
{
    
  
//    init(amplitudeCallback: @escaping (Float) -> Void) 
//    {
//        self.amplitudeCallback = amplitudeCallback
//        setupAudioEngine()
//    }
  
    
}


/*
 * ****** 播放录音 ******
 */
public enum LGAudioPlayerState : NSInteger
{
    case LGAudioPlayerStateNormal/** 未播放状态 */
    case LGAudioPlayerStatePlaying/** 正在播放 */
    case LGAudioPlayerStateCancel/** 播放被取消 */
}

public protocol LGAudioPlayerDelegate: AnyObject
{
    
    func audioPlayerStateDidChanged(audioPlayerState: LGAudioPlayerState, forIndex: NSInteger)
}

public class LGSoundPlayer: NSObject, AVAudioPlayerDelegate
{
    static let shared = LGSoundPlayer()
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioPlayer: AVAudioPlayer!
    var audioPlayerState = LGAudioPlayerState.LGAudioPlayerStateNormal
    public var URLString: NSString = ""
    public var index: NSInteger = 0
    public weak var delegate: LGAudioPlayerDelegate?
    public func playAudio(fileName: NSString)
    {
        // 检查文件是否存在
        if FileManager.default.fileExists(atPath: "\(fileName)") {
            print("File exists at path: \(URLString)")
            guard let url = URL(string: fileName as String) else {
                FLPrint("Invalid URL")
                return
            }
            
            do {
                // 直接从 URL 创建 AVAudioPlayer
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 1.0
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
                audioPlayerState = .LGAudioPlayerStatePlaying // 更新状态
            } catch let error {
                FLPrint("Error playing audio: \(error.localizedDescription)")
            }
            // 在这里使用 AVAudioPlayer 或其他方法来播放文件
        } else {
            print("File does not exist at expected path.")
        }
    }
    
    public func stopAudioPlayer()
    {
        audioPlayerState = LGAudioPlayerState.LGAudioPlayerStateCancel
    }
    
    //MARK: AVAudioPlayerDelegate
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        audioPlayerState = LGAudioPlayerState.LGAudioPlayerStateNormal
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        audioPlayerState = LGAudioPlayerState.LGAudioPlayerStateNormal
    }
}
