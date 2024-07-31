//
//  KingfisherViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/31.
//

import UIKit
import Kingfisher

class KingfisherViewController: FLBaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray =
        [
            "一、Kingfisher的使用",
        ]
        dataArray =
        [
            [
                "11",
                "22"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "Kingfisher"
        view.addSubview(tableView)
    }
}

// MARK: - 一、使用 Kingfisher.
extension KingfisherViewController
{
    // MARK:1.0.101.
    @objc func test101()
    {
        let imageView = UIImageView(frame: CGRect(x: screenW()/2 - 130, y: screenH()/2 - 190, width: 260, height: 380))
        let imageURL = URL(string: "https://img0.baidu.com/it/u=3460931629,1559324356&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=1200")
        imageView.kf.setImage(with: imageURL)
        view.addSubview(imageView)
//        self.view.addSubview(label)
        self.perform(#selector(afterLoad), with: imageView, afterDelay: 6)
    }
    
    @objc func afterLoad(view : Any)
    {
        (view as AnyObject).removeFromSuperview()
    }
    
    func removeAllSubviews(from superview: UIView) {
        for subview in superview.subviews {
            subview.removeFromSuperview()
            removeAllSubviews(from: subview)
        }
    }
    
}
