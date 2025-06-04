//
//  FLHelloTalkViewController.swift
//  IOS-Swift
//
//  Created by hardy on 5/29/25.
//

import UIKit
import Speech
import AVFoundation

class FLHelloTalkViewController: UIViewController {

    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 12
        tv.text = "识别结果将显示在这里..."
        tv.textColor = .placeholderText
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
       
    private let recordButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("开始录音", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 40
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
       
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "准备就绪"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
       
    // MARK: - Speech Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
       
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        requestPermissions()
        
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
    }
       
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "语音转文字"
        
        view.addSubview(textView)
        view.addSubview(recordButton)
        view.addSubview(statusLabel)
        
    }
       
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 50),
            recordButton.widthAnchor.constraint(equalToConstant: 80),
            recordButton.heightAnchor.constraint(equalToConstant: 80),
            
            statusLabel.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
       
    // MARK: - Permission Handling
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self?.statusLabel.text = "已授权语音识别"
                    self?.recordButton.isEnabled = true
                case .denied:
                    self?.statusLabel.text = "用户拒绝语音识别权限"
                    self?.recordButton.isEnabled = false
                case .restricted:
                    self?.statusLabel.text = "设备限制语音识别"
                    self?.recordButton.isEnabled = false
                case .notDetermined:
                    self?.statusLabel.text = "未决定语音识别权限"
                    self?.recordButton.isEnabled = false
                @unknown default:
                    fatalError("未知授权状态")
                }
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.recordButton.isEnabled = true
                } else {
                    self?.statusLabel.text = "需要麦克风权限"
                    self?.recordButton.isEnabled = false
                }
            }
        }
        
    }
       
    // MARK: - Recording Control
    @objc private func toggleRecording() {
        if audioEngine.isRunning {
            stopRecording()
            recordButton.setTitle("开始录音", for: .normal)
            recordButton.backgroundColor = .systemRed
            statusLabel.text = "已停止录音"
        } else {
            startRecording()
            recordButton.setTitle("停止录音", for: .normal)
            recordButton.backgroundColor = .systemBlue
            statusLabel.text = "正在录音..."
        }
    }
       
       
    private func startRecording() {
        // 清除之前的任务
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // 准备音频会话
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话配置失败: \(error)")
            return
        }
        
        // 创建识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("无法创建识别请求") }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 配置音频引擎
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("音频引擎启动失败: \(error)")
            return
        }
        
        // 开始识别
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                self.textView.textColor = .label
                isFinal = result.isFinal
            }
            
            if let error = error {
                self.statusLabel.text = "识别错误: \(error.localizedDescription)"
                self.stopRecording()
            }
            
            if isFinal || error != nil {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
    }
       
    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
