//
//  ChatHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class ChatHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initUI()
    }
    
    func initUI()
    {
        self.title = "聊天"
        view.backgroundColor = .white
    }
}
