//
//  FLChatDetailCell.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/11.
//

import UIKit

class FLChatBaseCell: UITableViewCell
{
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) 
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageV)
    }
    
    func setAvatar(with model: FLChatMsgModel)
    {
        avatarImageV.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
        if model.isMe {
            avatarImageV.snp.remakeConstraints { make in
                make.right.equalTo(-20)
                make.width.height.equalTo(55)
                make.top.equalTo(15)
            }
        }else{
            avatarImageV.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.width.height.equalTo(55)
                make.top.equalTo(15)
            }
        }
    }
    
    var avatarImageV: UIImageView =
    {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
}

class ChatTextMessageCell: FLChatBaseCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Chat_Cell_Background_Gray
        contentView.addSubview(bubbleImageV)
        bubbleImageV.addSubview(messageLabel)
    }
    
    func setModel(with model: FLChatMsgModel)
    {
        /**
         * 头像
         */
        super.setAvatar(with: model)
        
        /**
         * 文字背景图片
         */
        let size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))

        if model.isMe {
            if let image = UIImage(named: "bg_chat_me")
            {
                bubbleImageV.image = image.stretchableImage(centerStretchScale: 0.65)
            }
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.right.equalTo(avatarImageV.snp_leftMargin).offset(-15)
                make.width.equalTo(size.width + 30)
                make.height.equalTo(size.height + 30)
            }
            
            messageLabel.snp.remakeConstraints { make in
                make.left.equalTo(bubbleImageV).offset(16)
                make.top.equalTo(bubbleImageV).offset(10)
                make.right.equalTo(bubbleImageV).offset(-10)
                make.bottom.equalTo(bubbleImageV).offset(-10)
            }
        } else {
            if let image = UIImage(named: "bg_chat_other")
            {
                bubbleImageV.image = image.stretchableImage(centerStretchScale: 0.65)
            }
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.left.equalTo(avatarImageV.snp_rightMargin).offset(15)
                make.width.equalTo(size.width + 30)
                make.height.equalTo(size.height + 30)
            }
            
            messageLabel.snp.remakeConstraints { make in
//                make.top.equalTo(bubbleImageV).offset(10)
                make.left.equalTo(bubbleImageV).offset(16)
//                make.bottom.equalTo(bubbleImageV).offset(-10)
                make.right.equalTo(bubbleImageV).offset(-10)
                make.centerY.equalTo(bubbleImageV)
                make.height.equalTo(size.height)
            }
        }
        
        /**
         * 文字消息
         */
        let attributedString = NSMutableAttributedString(string: model.contentStr)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(attributedString.string.startIndex..., in: attributedString.string))
        messageLabel.attributedText = attributedString
    }
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bubbleImageV: UIImageView =
    {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var messageLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
}
