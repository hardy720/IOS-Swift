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
        let size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(chart_cell_text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))
        if model.isMe {
            if let image = UIImage(named: "bg_chat_me")
            {
                bubbleImageV.image = image.resizableImageWithCenteredStretch(top: 20, left: 10, bottom: 20, right: 10)
            }
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.right.equalTo(avatarImageV.snp_leftMargin).offset(-15)
                make.width.equalTo(size.width + 30)
                make.height.equalTo(size.height + 30)
            }
        } else {
            if let image = UIImage(named: "bg_chat_other")
            {
                bubbleImageV.image = image.resizableImageWithCenteredStretch(top: 20, left: 10, bottom: 20, right: 10)
            }
            
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.left.equalTo(avatarImageV.snp_rightMargin).offset(15)
                make.width.equalTo(size.width + 30)
                make.height.equalTo(size.height + 30)
            }
        }
        
        /**
         * 文字消息
         */
        let attributedString = NSMutableAttributedString(string: model.contentStr)
        // 设置字符间距，这里以2.0为例
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.0, range: NSRange(model.contentStr.startIndex..., in: model.contentStr))
        messageLabel.attributedText = attributedString
//        messageLabel.text = model.contentStr
        messageLabel.snp.remakeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
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
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
}
