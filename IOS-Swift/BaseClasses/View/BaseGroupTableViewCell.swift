//
//  BaseGroupTableViewCell.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit
import SnapKit


import UIKit
import SnapKit

class BaseGroupTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(lineView)
        self.initLayout()
    }
    
    func initLayout() {
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 1))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .FLGlobalColor()
        return view
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
