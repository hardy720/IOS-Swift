//
//  FLCustomKeyboardView.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/17.
//

import UIKit

class FLCustomKeyboardView: UIView 
{
    let backView : UIView = {
        let backView = UIView()
        backView.backgroundColor = Chat_CustomKeyBoard_Back_Gray
        return backView
    }()
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .red
        return textView
    }()
    
    let voiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "chat_keyboard_voice"), for: .normal)
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
        backView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(Chat_Custom_Keyboard_Height)
        }
        voiceButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(40)
        }
        
        inputTextView.snp.makeConstraints { make in
//            make.centerY.equalTo(self)
            make.left.equalTo(voiceButton.snp_rightMargin).offset(15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.right.equalTo(-130)
        }
    }
    
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FLCustomKeyboardView
{
    @objc func handleVoiceButtonTap()
    {
        print("123")
    }
}
