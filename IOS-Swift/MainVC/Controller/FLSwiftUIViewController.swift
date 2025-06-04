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
        dataArray = ["Extension","Summary","LibraryStudy","SwiftUI","Test"];
        unsafeUnwrap()
        testAnalyzer()
    }
    
    func testAnalyzer() {
        let optionalValue: Int? = nil
        let forcedValue = optionalValue! // 强制解包 nil 应触发警告
    }
    
    func unsafeUnwrap()
    {
        var name: String? = nil
//        print(name!) // ⚠️ Static Analyzer 会标记此处为 "Force unwrapped nil"
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
