//
//  FLSwiftUIViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2025/2/24.
//

import UIKit

class FLSwiftUIViewController: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    private func initUI()
    {
        self.title = "SwiftUI"
        view.addSubview(tableView)
    }
    
    private func initData()
    {
        dataArray = ["Extension","Summary","LibraryStudy","Playground","SwiftUI","Test"];
    }
}
