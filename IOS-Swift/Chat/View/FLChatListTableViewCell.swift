//
//  FLChatListTableViewCell.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/9.
//

import UIKit

class FLChatListTableViewCell: UITableViewCell 
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(nickNameLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(lastContentLabel)
        self.contentView.addSubview(messageAlertLabel)
        self.initLayout()
    }
    
    func setModel(model: FLChatListModel)
    {
        avatarImage.kf.setImage(with: URL(string: model.friendAvatar), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
        nickNameLabel.text = model.friendName
        timeLabel.text = model.updateTime
        lastContentLabel.text = model.lastText
        if model.messageAlert > 0 {
            messageAlertLabel.isHidden = false
            messageAlertLabel.text = "\(model.messageAlert)"
        }else{
            messageAlertLabel.isHidden = true
        }
    }
    
    func initLayout()
    {
        avatarImage.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.height.equalTo(50)
            make.centerY.equalTo(self.contentView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(avatarImage)
            make.height.equalTo(18)
            make.width.equalTo(200)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImage.snp_rightMargin).offset(20)
            make.top.equalToSuperview().offset(10)
            make.right.equalTo(timeLabel.snp_leftMargin).offset(-20)
            make.height.equalTo(25)
        }
        
        lastContentLabel.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel)
            make.right.equalTo(timeLabel)
            make.bottom.equalTo(avatarImage)
            make.height.equalTo(20)
        }
        
        messageAlertLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage).offset(-10)
            make.right.equalTo(avatarImage).offset(10)
            make.width.height.equalTo(16)
        }
    }
    
    var avatarImage: UIImageView =
    {
        let avatarImage = UIImageView.init()
        avatarImage.layer.cornerRadius = 5
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()
    
    var nickNameLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    var timeLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Text_Light_Gray
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    var lastContentLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = Text_Light_Gray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    var messageAlertLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .red
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.numberOfLines = 1
        return label
    }()
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}
