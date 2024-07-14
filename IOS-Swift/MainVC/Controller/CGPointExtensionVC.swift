//
//  CGPointExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/14.
//

import UIKit

class CGPointExtensionVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray = ["一、CGPoint的基本扩展"]
        dataArray = [["两个CGPoint进行 - 运算", "计算两个 CGPoint 的中点"]]
    }
    
    func initUI() 
    {
        self.title = "CGPoint+Extension"
        view.addSubview(tableView)
    }
}

// MARK: - 一、CGPoint的基本扩展
extension CGPointExtensionVC
{
    // MARK: 1.01、两个CGPoint进行 - 运算
    @objc func test101()
    {
        let point1 = CGPoint(x: 20, y: 40)
        let point2 = CGPoint(x: 10, y: 90)
        let s = point2 - point1
        FLPrint("两个CGPoint进行 - 运算：点1：\(point1) 点2：\(point2) 进行 - 运算的结果是：\(point1 - point2)")
    }
    
    // MARK: 1.02、计算两个 CGPoint 的中点
    @objc func test102() 
    {
        let point1 = CGPoint(x: 20, y: 40)
        let point2 = CGPoint(x: 10, y: 90)
        FLPrint("点1：\(point1) 点2：\(point2) 之间的中间点是：\(point1.midPoint(by: point2))")
    }
}
