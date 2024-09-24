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
        button.addTarget(self, action: #selector(handleVoiceButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    @objc func handleVoiceButtonTap()
    {
        print("123")
    }
    
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
    func adjustTextViewHeight() 
    {
        
    }
}
