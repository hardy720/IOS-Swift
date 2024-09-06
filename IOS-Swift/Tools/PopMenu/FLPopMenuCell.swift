//
//  FLPopMenuCell.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/5.
//

import UIKit

class FLPopMenuCell: UITableViewCell
{
    // MARK: - setter && getter
    var model: FLCellDataConfig? {
        didSet {
            guard let model = model else {
                return
            }
            
            titleLabel.text = model.title
            leftImageView.image = UIImage(named: model.image!)
            lineView.isHidden = !model.isShow
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        self.makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI()
    {
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }

}


class FLCellDataConfig: NSObject
{
    var title: String?
    var subtitle: String?
    var image: String?
    var isShow: Bool = false
    
    var targetVC: UIViewController?
    
    public init(title: String? = "", subtitle: String? = "", image : String? = "", isShow: Bool = false, targetVC: UIViewController? = nil) {
        super.init()
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        self.isShow = isShow
        self.targetVC = targetVC
    }
}

