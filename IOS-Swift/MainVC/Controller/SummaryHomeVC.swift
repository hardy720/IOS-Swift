//
//  SummaryHomeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/11.
//

import UIKit

class SummaryHomeVC: FLBaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    func initData() 
    {
        headDataArray = ["一、语言基础"]
        dataArray = [["struct","泛型","Where","元组","枚举"]]
    }
    
    func initUI()  
    {
        self.title = "Summary"
        view.addSubview(tableView)
    }
}

// MARK: - 一、语言基础
extension SummaryHomeVC
{
    // MARK: 1.01 struct
    @objc func test101()
    {
        self.navigationController?.pushViewController(StructDetailVC.init(), animated: true)
    }
}
