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
    }
    
    func setBubbleImage(with model: FLChatMsgModel)
    {
        contentView.addSubview(bubbleImageV)
        var size : CGSize = CGSizeZero
        if model.msgType == .msg_text {
            size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))
            size.height = size.height + 30
            size.width = size.width + 30
        }
        
        if model.msgType == .msg_audio {
            size.height = 50
            size.width = calculateWidth(index: Int(model.mediaTime) ?? 3, screenWidth: Chat_Cell_Audio_Max_Width)
        }

        if model.isMe {
            if let image = UIImage(named: "bg_chat_me")
            {
                bubbleImageV.image = image.stretchableImage(centerStretchScale: 0.65)
            }
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.right.equalTo(avatarImageV.snp_leftMargin).offset(-15)
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }else{
            if let image = UIImage(named: "bg_chat_other")
            {
                bubbleImageV.image = image.stretchableImage(centerStretchScale: 0.65)
            }
            bubbleImageV.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageV)
                make.left.equalTo(avatarImageV.snp_rightMargin).offset(15)
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
    }
    
    func setAvatar(with model: FLChatMsgModel)
    {
        contentView.addSubview(avatarImageV)
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
    
    var bubbleImageV: UIImageView =
    {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
}

// MARK: - 文字Cell -
class ChatTextMessageCell: FLChatBaseCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Chat_Cell_Background_Gray
        bubbleImageV.addSubview(messageLabel)
    }
    
    func setModel(with model: FLChatMsgModel)
    {
        /**
         * 头像
         */
        super.setAvatar(with: model)
        
        /**
         * 消息背景图片
         */
        super.setBubbleImage(with: model)
        
        /**
         * 文字背景图片
         */
        let size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))

        if model.isMe {
            messageLabel.snp.remakeConstraints { make in
                make.left.equalTo(bubbleImageV).offset(16)
                make.top.equalTo(bubbleImageV).offset(10)
                make.right.equalTo(bubbleImageV).offset(-10)
                make.bottom.equalTo(bubbleImageV).offset(-10)
            }
        } else {
            messageLabel.snp.remakeConstraints { make in
                make.left.equalTo(bubbleImageV).offset(16)
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
    
    var messageLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
}

// MARK: - 录音Cell -
class ChatAudioMessageCell: FLChatBaseCell, LGAudioPlayerDelegate
{
    var msgModel : FLChatMsgModel? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Chat_Cell_Background_Gray
    }
    
    var audioImageV : UIImageView =
    {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    func setModel(with model: FLChatMsgModel)
    {
        msgModel = model
        /**
         * 头像
         */
        super.setAvatar(with: model)
        
        /**
         * 消息背景图片
         */
        super.setBubbleImage(with: model)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        bubbleImageV.isUserInteractionEnabled = true
        bubbleImageV.addGestureRecognizer(tap)
        
        /**
         * 语音图片
         */
        bubbleImageV.addSubview(audioImageV)
        
        /**
          * 语音时长
         */
        bubbleImageV.addSubview(timeLabel)
        
        /**
         * 未读红点
         */
        contentView.addSubview(redDotLabel)
        
        if model.isMe {
            audioImageV.image = UIImage(named: "icon_chat_audio_right")
            audioImageV.snp.remakeConstraints { make in
                make.right.equalTo(bubbleImageV).offset(-15)
                make.centerY.equalTo(bubbleImageV)
                make.width.height.equalTo(20)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.right.equalTo(audioImageV.snp_leftMargin).offset(-8)
                make.centerY.equalTo(audioImageV)
                make.height.equalTo(16)
                make.width.equalTo(50)
            }
            timeLabel.textAlignment = .right
            redDotLabel.removeFromSuperview()
        }else{
            audioImageV.image = UIImage(named: "icon_chat_audio_left")
            audioImageV.snp.remakeConstraints { make in
                make.left.equalTo(bubbleImageV).offset(15)
                make.centerY.equalTo(bubbleImageV)
                make.width.height.equalTo(20)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.left.equalTo(audioImageV.snp_rightMargin).offset(10)
                make.centerY.equalTo(audioImageV)
                make.height.equalTo(16)
                make.width.equalTo(50)
            }
            timeLabel.textAlignment = .left
            
            redDotLabel.snp.remakeConstraints { make in
                make.left.equalTo(bubbleImageV.snp_rightMargin).offset(6)
                make.centerY.equalTo(timeLabel)
                make.width.height.equalTo(10)
            }
        }
        timeLabel.text = "\(model.mediaTime)" + "\""
    }
    
    var redDotLabel : UILabel =
    {
        let label = UILabel.init()
        label.backgroundColor = .red
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    var timeLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Audio_Time))
        label.textColor = .black
        return label
    }()
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapClick ()
    {
        guard let documentsURL = getSandbox_document() else {
            return
        }
        let recordPath = documentsURL.path() + getRecordPath + "/" + (msgModel?.contentStr ?? "")
        LGSoundPlayer.shared.playAudio(fileName:recordPath as NSString)
        LGSoundPlayer.shared.delegate = self

        var images: [UIImage]?
        if let msgModel = msgModel, msgModel.isMe {
            images = [UIImage(named: "icon_chat_keyboard_voice_right_1")!, UIImage(named: "icon_chat_keyboard_voice_right_2")!, UIImage(named: "icon_chat_keyboard_voice_right_3")!]
        }else{
            images = [UIImage(named: "icon_chat_keyboard_voice_left_1")!, UIImage(named: "icon_chat_keyboard_voice_left_2")!, UIImage(named: "icon_chat_keyboard_voice_left_3")!]
        }
        audioImageV.animationImages = images
        audioImageV.animationDuration = 1.0
        audioImageV.animationRepeatCount = 0
        audioImageV.startAnimating()
    }
    
    func audioPlayerStateDidChanged(_audioPlayerState: LGAudioPlayerState)
    {
        switch _audioPlayerState {
        case .LGAudioPlayerStateNormal:
            FLPrint("播放结束")
            audioImageV.stopAnimating()
            break
        
        default:
            break
        }
    }
}


// MARK: - 图片Cell -
class ChatImgMessageCell: FLChatBaseCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Chat_Cell_Background_Gray
        contentView.addSubview(contentImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(with model: FLChatMsgModel)
    {
        /**
         * 头像
         */
        super.setAvatar(with: model)
        if model.isMe {
            contentImg.snp.updateConstraints { make in
                make.right.equalTo(avatarImageV.snp_leftMargin).offset(-20)
                make.top.equalTo(avatarImageV)
                make.width.equalTo(model.imgWidth)
                make.height.equalTo(model.imgHeight)
            }
        }else{
            contentImg.snp.updateConstraints { make in
                make.left.equalTo(avatarImageV.snp_rightMargin).offset(20)
                make.top.equalTo(avatarImageV)
                make.width.equalTo(model.imgWidth)
                make.height.equalTo(model.imgHeight)
            }
        }
        
        let imgaPath = BASE_URL_IMAGE + model.contentStr
        contentImg.kf.setImage(with: URL(string: imgaPath), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
        
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("无法获取Documents目录路径")
//            return
//        }
//        let chatFolderPath = documentsDirectory.appendingPathComponent(getImgPath)
//        let filePath = chatFolderPath.appendingPathComponent(model.contentStr)
//        
//        if let image = UIImage(contentsOfFile: filePath.path) {
//            contentImg.image = image
//        } else {
//            print("无法加载图片")
//        }
    }
    
    var contentImg: UIImageView =
    {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
}
