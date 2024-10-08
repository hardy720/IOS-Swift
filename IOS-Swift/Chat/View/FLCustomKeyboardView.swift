//
//  FLCustomKeyboardView.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/17.
//

import UIKit

protocol FLCustomKeyboardViewDelegate : AnyObject
{
    func didChangeText(_ text: String)
    func didChangeTVHeight(_ height: CGFloat)
}

class FLCustomKeyboardView: UIView
{
    weak var delegate: FLCustomKeyboardViewDelegate?
    private var isVoiceBtn = false
    lazy var backView : UIView = {
        let backView = UIView()
        backView.backgroundColor = Chat_CustomKeyBoard_Back_Gray
        return backView
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: CGFloat(Chart_Keyboard_TextView_font))
        textView.backgroundColor = .white
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.returnKeyType = .send
        textView.delegate = self
        textView.textColor = .black
        return textView
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_chat_keyboard_voice_hl"), for: .normal)
        button.addTarget(self, action: #selector(handleVoiceButtonTap(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var recordButton: FLRecordButton = {
        let button = FLRecordButton.init()
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI()
    {
        self.addSubview(backView)
        backView.addSubview(inputTextView)
        backView.addSubview(voiceButton)
        self.initLayout()
    }
    
    private func initLayout()
    {
        backView.snp.updateConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        voiceButton.snp.updateConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(self).offset(-15)
            make.height.width.equalTo(40)
        }
        
        inputTextView.snp.updateConstraints { make in
            make.left.equalTo(voiceButton.snp_rightMargin).offset(15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.right.equalTo(-60)
        }
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegate -
extension FLCustomKeyboardView: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n" {
            print("Return key pressed")
            // 如果不需要在文本视图中插入换行符，则返回 false
            // 这会阻止文本视图自动添加新行
            delegate?.didChangeText(textView.text)
            textView.text = ""
            initLayout()
            return false
        }
        // 如果不是回车键，则允许更改文本
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        let size = textView.text.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Keyboard_TextView_font)), size: CGSize(width: textView.frame.size.width - 10, height: CGFloat(MAXFLOAT)))
        FLPrint("======\(self.frame.size.height)")
        if size.height > self.frame.size.height - 30 {
            delegate?.didChangeTVHeight(30)
            initLayout()
        }
    }
}

// MARK: - Tools -
extension FLCustomKeyboardView
{
    @objc func handleVoiceButtonTap(_ button: UIButton)
    {
        if isVoiceBtn {
            button.setImage(UIImage(named: "icon_chat_keyboard_voice_hl"), for: .normal)
            isVoiceBtn = false
            inputTextView.becomeFirstResponder()
            recordButton.removeFromSuperview()
        }else{
            button.setImage(UIImage(named: "icon_chat_keyboard"), for: .normal)
            isVoiceBtn = true
            self.endEditing(true)
            inputTextView.addSubview(recordButton)
            recordButton.frame = CGRectMake(0, 0, inputTextView.frame.size.width, inputTextView.frame.size.height)
        }
    }
}

/**
 * - 自定义录音按钮 -
 */
class FLRecordButton: UIButton
{
    // 定义回调类型
    typealias RecordTouchDown = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchUpOutside = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchUpInside = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchDragEnter = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchDragInside = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchDragOutside = (_ recordButton: FLRecordButton) -> Void
    typealias RecordTouchDragExit = (_ recordButton: FLRecordButton) -> Void
      
    // 回调属性
    var recordTouchDownAction: RecordTouchDown?
    var recordTouchUpOutsideAction: RecordTouchUpOutside?
    var recordTouchUpInsideAction: RecordTouchUpInside?
    var recordTouchDragEnterAction: RecordTouchDragEnter?
    var recordTouchDragInsideAction: RecordTouchDragInside?
    var recordTouchDragOutsideAction: RecordTouchDragOutside?
    var recordTouchDragExitAction: RecordTouchDragExit?
    
    var recordeAnimationView : FLRecordAnimationView?
      
    override init(frame: CGRect) 
    {
        super.init(frame: frame)
        self.setup()
    }
      
    required init?(coder: NSCoder) 
    {
        super.init(coder: coder)
        self.setup()
    }
      
    private func setup() 
    {
        self.backgroundColor = Chat_CustomKeyBoard_Back_Start_RecordVoice
        self.setTitle(Chat_Keyboard_Hold_Speak, for: .normal)
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(white: 0.6, alpha: 1.0).cgColor
          
        self.addTarget(self, action: #selector(recordTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(recordTouchUpOutside), for: .touchUpOutside)
        self.addTarget(self, action: #selector(recordTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(recordTouchDragEnter), for: .touchDragEnter)
        self.addTarget(self, action: #selector(recordTouchDragInside), for: .touchDragInside)
        self.addTarget(self, action: #selector(recordTouchDragOutside), for: .touchDragOutside)
        self.addTarget(self, action: #selector(recordTouchDragExit), for: .touchDragExit)
    }
      
    // 开始录音
    @objc func recordTouchDown()
    {
        recordTouchDownAction?(self)
        setButtonStateWithRecording()
        recordeAnimationView = FLRecordAnimationView.init()
        recordeAnimationView?.startAnimationView()
    }
      
    @objc func recordTouchUpOutside() 
    {
        recordTouchUpOutsideAction?(self)
        setButtonStateWithNormal()
    }
      
    // 完成录音
    @objc func recordTouchUpInside()
    {
        recordTouchUpInsideAction?(self)
        setButtonStateWithNormal()
        recordeAnimationView?.stopAnimationView()
    }
      
    @objc func recordTouchDragEnter()
    {
        recordTouchDragEnterAction?(self)
    }
      
    @objc func recordTouchDragInside()
    {
        recordTouchDragInsideAction?(self)
    }
      
    @objc func recordTouchDragOutside() 
    {
        recordTouchDragOutsideAction?(self)
    }
      
    @objc func recordTouchDragExit() 
    {
        recordTouchDragExitAction?(self)
    }
      
    func setButtonStateWithRecording()
    {
        if FLAudioRecorder.shared.getAuthorizedStatus() {
            self.backgroundColor = Chat_CustomKeyBoard_Back_RecordVoice
            self.setTitle(Chat_Keyboard_Release_End, for: .normal)
        }
    }
      
    func setButtonStateWithNormal() 
    {
        self.backgroundColor = Chat_CustomKeyBoard_Back_Start_RecordVoice
        self.setTitle(Chat_Keyboard_Hold_Speak, for: .normal)
    }
}


/**
 * - 自定义录音动画 -
 */
class FLRecordAnimationView : UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    func startAnimationView()
    {
        getKeyWindow().addSubview(backView!)
        backView!.addSubview(boxView!)
        boxView!.addSubview(recordImageV!)
        boxView!.addSubview(cancelAlertLabel!)
        
        initLayout()
    }
    
    func initLayout()
    {
        boxView?.frame = CGRectMake(screenW()/2 - 100, screenH()/2 - 100, 200, 200)
        recordImageV?.snp.makeConstraints { make in
            make.centerY.equalTo(boxView!)
            make.left.equalTo(50)
            make.height.equalTo(70)
            make.width.equalTo(45)
        }
        
        cancelAlertLabel!.snp.makeConstraints { make in
            make.centerX.equalTo(boxView!)
            make.bottom.equalTo(-20)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
    }
    
    
    
    func stopAnimationView()
    {
        backView?.removeFromSuperview()
        FLPrint("\(Thread.current)")
        backView = nil
        boxView = nil
        recordImageV = nil
        cancelAlertLabel = nil
    }
    
    // 背景view
    lazy var backView: UIView? = {
        let view = UIView(frame: CGRectMake(0, 0, screenW(), screenH()))
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    // 小方块view
    lazy var boxView: UIView? = {
        let view = UIView.init()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    var recordImageV: UIImageView? =
    {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "icon_chat_keyboard_voice_record")
        return imageView
    }()
    
    var cancelAlertLabel : UILabel? = {
        let label = UILabel.init()
        label.text = Chat_Keyboard_Cancel_Record_Alert
        label.font = UIFont.systemFont(ofSize: CGFloat(Chart_Keyboard_Record_Cancel_Alert_font))
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}
