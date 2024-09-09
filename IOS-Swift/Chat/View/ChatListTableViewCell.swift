//
//  ChatListTableViewCell.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/9.
//

import UIKit

class ChatListTableViewCell: UITableViewCell 
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(nickNameLabel)
        self.contentView.addSubview(lastContentLabel)
        self.initLayout()
    }
    
    func setModel(model: ChatListModel)
    {
        avatarImage.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
        nickNameLabel.text = model.nickName
        lastContentLabel.text = model.lastContent
    }
    
    func initLayout()
    {
        avatarImage.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.height.equalTo(50)
            make.centerY.equalTo(self.contentView)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImage.snp_rightMargin).offset(20)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(25)
        }
        
        lastContentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nickNameLabel)
            make.bottom.equalTo(avatarImage)
            make.height.equalTo(20)
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
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = UIColor.hexStringColor(hexString: "#333333")
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    var lastContentLabel : UILabel =
    {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}