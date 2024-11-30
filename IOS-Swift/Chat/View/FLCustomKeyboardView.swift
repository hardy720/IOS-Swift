//
//  FLCustomKeyboardView.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/17.
//

import UIKit

protocol FLCustomKeyboardViewDelegate : AnyObject
{
    // 文字消息
    func didChangeText(_ text: String)
    func didChangeTVHeight(_ height: CGFloat)
    
    // 录音消息
    func startRecording()
    func errorRecordPermission()
    func errorShort()
    func FinishRecord()
    func recordChangeCustomKeyboardViewFrame()
    
    // 增加的另外的功能.
    func startShowAdd()
    func moreAddIndex(index:Int)
}


enum FLInputViewState {
    case textInput
    case voiceInput
    case moreOptions
}

class FLCustomKeyboardView: UIView
{
    weak var delegate: FLCustomKeyboardViewDelegate?
    private var isVoiceBtn = false
    var isShowAddView = false
    var recordeAnimationView : FLRecordAnimationView?
    var userId : String?
    
    var currentState: FLInputViewState = .textInput {
        didSet {
            self.initLayout()
        }
    }
    
    lazy var backView : UIView = {
        let backView = UIView()
        backView.backgroundColor = Chat_CustomKeyBoard_Back_Gray
        backView.backgroundColor = .green
        return backView
    }()
    
    lazy var addView : FLAddView = {
        let view = FLAddView()
        view.delegate = self
        return view
    }()
    
    lazy var itemBackView : UIView = {
        let backView = UIView()
        backView.backgroundColor = Chat_CustomKeyBoard_Back_Gray
        backView.backgroundColor = .red
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
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_chat_keyboard_voice_more_ios"), for: .normal)
        button.addTarget(self, action: #selector(handleAddButtonTap(_:)), for: .touchUpInside)
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
        initRecord()
        initNoti()
    }
        
    private func setupUI()
    {
        self.addSubview(backView)
        backView.addSubview(itemBackView)
        itemBackView.addSubview(inputTextView)
        itemBackView.addSubview(voiceButton)
        itemBackView.addSubview(addButton)
        backView.addSubview(addView)

        self.initLayout()
    }
    
    private func initLayout()
    {
        let size = inputTextView.text.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Keyboard_TextView_font)), size: CGSize(width: inputTextView.frame.size.width - 10, height: CGFloat(MAXFLOAT)))
        var itemBackViewHeight = 0
        switch currentState {
        case .textInput:
            if inputTextView.text.fl.isStringBlank() {
                itemBackViewHeight = Int(Chat_Custom_Keyboard_Height)
            }else{
                itemBackViewHeight = Int(size.height + Chat_Custom_Keyboard_Input_Margin)
            }
            break
        case .voiceInput:
            itemBackViewHeight = Int(Chat_Custom_Keyboard_Height)
//            recordButton.frame = CGRectMake(0, 0, inputTextView.frame.size.width, inputTextView.frame.size.height)
            break
        case .moreOptions:
            break
        }
        

        backView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        itemBackView.snp.updateConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(itemBackViewHeight)
        }
        
        inputTextView.snp.updateConstraints { make in
            make.left.equalTo(60)
            make.top.equalTo(15)
            make.height.equalTo(size.height + 20)
            make.right.equalTo(-60)
        }
        
        voiceButton.snp.updateConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(inputTextView)
            make.height.width.equalTo(35)
        }
        
        addButton.snp.updateConstraints { make in
            make.bottom.equalTo(voiceButton)
            make.right.equalTo(itemBackView).offset(-10)
            make.height.width.equalTo(35)
        }
        
        addView.snp.updateConstraints { make in
            make.bottom.left.right.equalTo(self).offset(-10)
            make.top.equalTo(itemBackView.snp_bottomMargin).offset(10)
        }
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 通知 -
extension FLCustomKeyboardView
{
    func initNoti()
    {
        // 注册键盘显示通知
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        // 注册键盘隐藏通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification)
    {
        self.frame = CGRect(x: 0, y: screenH() - self.frame.size.height - fWindowSafeAreaInset().bottom, width: screenW(), height:self.frame.size.height)
    }
}

extension FLCustomKeyboardView: UITextViewDelegate,FLSoundRecorderDelegate,FLAddViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n" {
            FLPrint("Return key pressed")
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
            delegate?.didChangeTVHeight(size.height)
            initLayout()
    }
    
    // 录音
    func soundRecordFailed()
    {
        
    }
    
    func soundRecordDidStop() 
    {
        
    }
    
    func soundRecordTooShort() 
    {
        delegate?.errorShort()
    }
    
    func soundRecordTimerTicks(second: NSInteger) 
    {
        
    }

    // 发送消息更多功能：图片、视频...
    func clickAddIndex(index: Int)
    {
        delegate?.moreAddIndex(index: index)
    }
}

// MARK: - Tools -
extension FLCustomKeyboardView
{
    // 键盘录音切换
    @objc func handleVoiceButtonTap(_ button: UIButton)
    {
        if isVoiceBtn {
            self.currentState = .textInput
            button.setImage(UIImage(named: "icon_chat_keyboard_voice_hl"), for: .normal)
            isVoiceBtn = false
            inputTextView.becomeFirstResponder()
            recordButton.removeFromSuperview()
        }else{
            button.setImage(UIImage(named: "icon_chat_keyboard"), for: .normal)
            isVoiceBtn = true
            delegate?.recordChangeCustomKeyboardViewFrame()
            self.currentState = .voiceInput
            inputTextView.addSubview(recordButton)
            self.endEditing(true)
        }
    }
    
    @objc func handleAddButtonTap(_ button: UIButton)
    {
        if isVoiceBtn {
            voiceButton.setImage(UIImage(named: "icon_chat_keyboard_voice_hl"), for: .normal)
            isVoiceBtn = false
            recordButton.removeFromSuperview()
        }else{
            
        }
        delegate?.startShowAdd()
    }
    
    // 设置声音大小的图片
    func setPicturesBySoundLevel(level: Float)
    {
        let levelInterval = Int((level * 5).rounded()) // 将 0.0-1.0 分为 5 个区间，每个区间 0.2
        if ((recordeAnimationView?.toastImageV) != nil) {
            switch levelInterval {
            case 0:
                UIView.transition(with: (recordeAnimationView?.toastImageV)!, duration: 0.5, options: .transitionCrossDissolve, animations:{
                    self.recordeAnimationView?.toastImageV?.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_1")
                }, completion: nil)
                break

            case 1:
                UIView.transition(with: (recordeAnimationView?.toastImageV)!, duration: 0.5, options: .transitionCrossDissolve, animations:{
                    self.recordeAnimationView?.toastImageV?.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_2")
                }, completion: nil)
                break
                
            case 2:
                UIView.transition(with: (recordeAnimationView?.toastImageV)!, duration: 0.5, options: .transitionCrossDissolve, animations:{
                    self.recordeAnimationView?.toastImageV?.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_3")
                }, completion: nil)
                break
                
            case 3:
                UIView.transition(with: (recordeAnimationView?.toastImageV)!, duration: 0.5, options: .transitionCrossDissolve, animations:{
                    self.recordeAnimationView?.toastImageV?.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_4")
                }, completion: nil)
                break
                
            case 4:
                UIView.transition(with: (recordeAnimationView?.toastImageV)!, duration: 0.5, options: .transitionCrossDissolve, animations:{
                    self.recordeAnimationView?.toastImageV?.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_5")
                }, completion: nil)
                break
                
            default:
                break
            }
        }
    }
    
    // 录音取消与否
    func setAnimationViewIsHidden(isRecord: Bool,isCancel: Bool)
    {
        self.recordeAnimationView?.toastImageV?.isHidden = isRecord
        self.recordeAnimationView?.cancelAlertLabel?.isHidden = isRecord
        self.recordeAnimationView?.recordImageV?.isHidden = isRecord
        self.recordeAnimationView?.cancelImageV?.isHidden = isCancel
        self.recordeAnimationView?.redCancelLabel?.isHidden = isCancel
    }
}


// MARK: - 录音 -
extension FLCustomKeyboardView
{
    func startRecordAnimation()
    {
        recordeAnimationView = FLRecordAnimationView.init()
        recordeAnimationView?.startAnimationView()
    }
    
    func initRecord()
    {
        FLAudioRecorder.shared.delegate = self
        // 开始录音
        self.recordButton.recordTouchDownAction = { [self] recordButton in
            FLPrint("Start recording")
            if FLAudioRecorder.shared.getAuthorizedStatus() {
                startRecordAnimation()
                delegate?.startRecording()
                guard let documentsURL = getSandbox_document() else {
                    return
                }
                let recordName = documentsURL.path() + getRecordPath + "/" + (userId ?? "-1") + "_" + Date.fl.currentDate_SSS_() + ".caf"
                let namename = (userId ?? "-1") + "_" + Date.fl.currentDate_SSS_() + ".caf"
                FLAudioRecorder.shared.startRecord(recordFileName: recordName as NSString, pathStr: namename as NSString) { maxAmplitude in
                    DispatchQueue.main.async {
                        self.setPicturesBySoundLevel(level: maxAmplitude)
                    }
                }
            }else{
                delegate?.errorRecordPermission()
            }
        }
        
        // 完成录音
        recordButton.recordTouchUpInsideAction = { recordButton in
            FLPrint("Finish recording")
            if FLAudioRecorder.shared.getAuthorizedStatus() {
                self.recordeAnimationView?.stopAnimationView()
                FLAudioRecorder.shared.stop()
                FLAudioRecorder.shared.stopSoundRecord()
                if FLAudioRecorder.shared.recordSeconds > 1 {
                    self.delegate?.FinishRecord()
                }
            }
        }
        
        // 取消录音
        recordButton.recordTouchUpOutsideAction = { recordButton in
            FLPrint("Cancel recording")
            FLAudioRecorder.shared.stop()
            FLAudioRecorder.shared.stop()
            FLAudioRecorder.shared.stopSoundRecord()
            self.recordeAnimationView?.stopAnimationView()
        }
        
        // 将取消录音
        recordButton.recordTouchDragExitAction = { recordButton in
            FLPrint("Recording will be canceled.")
            
            self.setAnimationViewIsHidden(isRecord: true, isCancel: false)
        }
        
        // 继续录音
        recordButton.recordTouchDragInsideAction = { recordButton in
            FLPrint("Keep recording.")
            self.setAnimationViewIsHidden(isRecord: false, isCancel: true)
        }
    }
    
    
}

// MARK - 自定义录音按钮 -
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


// MARK - 自定义录音动画 -
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
        boxView!.addSubview(toastImageV!)
        boxView!.addSubview(cancelImageV!)
        boxView!.addSubview(redCancelLabel!)

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
        
        toastImageV!.snp.makeConstraints { make in
            make.centerY.equalTo(recordImageV!)
            make.left.equalTo(recordImageV!.snp_rightMargin).offset(25)
            make.height.equalTo(recordImageV!)
            make.width.equalTo(40)
        }
        
        cancelImageV?.snp.makeConstraints({ make in
            make.centerX.equalTo(boxView!)
            make.centerY.equalTo(boxView!).offset(-20)
            make.height.width.equalTo(50)
        })
        
        redCancelLabel?.snp.makeConstraints({ make in
            make.centerX.equalTo(boxView!)
            make.bottom.equalTo(-20)
            make.height.equalTo(20)
            make.width.equalTo(130)
        })
    }
    
    func stopAnimationView()
    {
        backView?.removeFromSuperview()
        FLPrint("\(Thread.current)")
        backView = nil
        boxView = nil
        recordImageV = nil
        cancelAlertLabel = nil
        toastImageV = nil
        cancelImageV = nil
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
    
    var toastImageV: UIImageView? =
    {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_2")
        return imageView
    }()
    
    var cancelImageV: UIImageView? =
    {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "icon_chat_keyboard_v_toast_vol_cancelsend")
        imageView.isHidden = true
        return imageView
    }()
    
    var redCancelLabel : UILabel? = {
        let label = UILabel.init()
        label.text = Chat_Keyboard_Cancel_Release_Record_Alert
        label.font = UIFont.systemFont(ofSize: CGFloat(Chart_Keyboard_Record_Cancel_Alert_font))
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.isHidden = true
        return label
    }()
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol FLAddViewDelegate : AnyObject
{
    func clickAddIndex(index: Int)
}

// MARK - 图片，视频等 -
class FLAddView : UIView
{
    weak var delegate: FLAddViewDelegate?
    let titleArr = ["相册","拍摄","位置"]
    let imgArr = ["icon_chat_keyboard_add_sharemore_pic","icon_chat_keyboard_add_sharemore_video","icon_chat_keyboard_add_sharemore_location"]

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backScrollV?.contentSize = CGSize(width: screenW(), height: Chat_Custom_Keyboard_AddView_Height)
        self.addSubview(backScrollV!)

        initLayout()
    }
    
    func initLayout()
    {
        backScrollV?.snp.makeConstraints({ make in
            make.top.bottom.right.left.equalTo(self)
        })
        
        for i in 0...titleArr.count - 1 {
            let colunm = i % 4;
            let row = i / 4;
            let btnWidth = (screenW() - 80)/4;
            let btnHeight = 70.0
            
            let button = UIButton(type: .custom)
            var configuration = UIButton.Configuration.filled()
            if let image = UIImage(named: self.imgArr[i])?.withRenderingMode(.automatic) {
                configuration.image = image
                configuration.imagePlacement = .top
                configuration.baseBackgroundColor = .clear
            }
            let attributedTitle = NSAttributedString(string: self.titleArr[i], attributes: [.foregroundColor: UIColor.black])
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.addTarget(self, action: #selector(itemBtnClick(_:)), for: .touchUpInside)
            button.tag = i + Tag_1000
            button.configuration = configuration
            button.setTitleColor(.black, for: .normal)
            button.frame = CGRect(x: 10 + CGFloat(colunm) * (btnWidth + 20), y: 10 + CGFloat(row) * (btnHeight + 20), width: btnWidth, height: btnHeight)
            backScrollV?.addSubview(button)
        }
    }
    
    @objc func itemBtnClick(_ btn: UIButton)
    {
        
        delegate?.clickAddIndex(index: btn.tag - Tag_1000)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backScrollV: UIScrollView? =
    {
        let scrollView = UIScrollView.init()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        return scrollView
    }()
}

