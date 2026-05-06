//
//  FLSwiftUIViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2025/2/24.
//

import UIKit
import SwiftUI

class FLSwiftUIViewController: FLBaseViewController{
    
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
        headDataArray = ["第一阶段：地基篇——认知与预备",
                         "第二阶段：实战篇"
        ]
        dataArray = [
            ["SwiftUI是一个声明式UI框架，这与传统的UIKit（命令式框架）有本质不同\n命令式编程：关注“如何做”。你需要一步步告诉程序创建UI元素、处理布局、响应用户事件等。\n声明式编程：关注“是什么”。你只需清晰地描述你想要的界面是什么样子"],
            [
                "认识最小 SwiftUI 视图\n目标：理解 View 协议和 body 属性。\n 练习：显示一段文字，并修改它的字体、颜色、背景。",
                "布局 – 使用 VStack / HStack / ZStack",
                "交互 – 按钮与 @State",
                "表单与输入 – TextField 与 @State",
                "列表与导航 – List + NavigationStack",
                "数据持久化 & MVVM – @StateObject / @ObservedObject",
                ".sheet 弹窗和 .alert",
                "学习动画：.animation 和 withAnimation",
                "@EnvironmentObject 全局共享数据（用户登录状态）",
                "在 SwiftUI 中使用 Task + async/await + Codable 发起网络请求。"
            ]
        ];
    }
}

extension FLSwiftUIViewController
{
    @objc func test101(){
        self.view.makeToast("SwiftUI是一个声明式UI框架，这与传统的UIKit（命令式框架）有本质不同\n命令式编程：关注“如何做”。你需要一步步告诉程序创建UI元素、处理布局、响应用户事件等。\n声明式编程：关注“是什么”。你只需清晰地描述你想要的界面是什么样子", duration: 12.0, position: .center)
    }
    
    @objc func test201(){
        let swiftUIView = SwiftUIViewPractice1()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test202(){
        let swiftUIView = SwiftUIViewPractice2()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test203(){
        let swiftUIView = SwiftUIViewPractice3()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test204(){
        let swiftUIView = SwiftUIViewPractice4()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test205(){
        let swiftUIView = SwiftUIViewPractice5()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
   
    @objc func test206(){
        let swiftUIView = SwiftUIViewPractice6()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    @objc func test207(){
        let swiftUIView = SwiftUIViewPractice7()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test208(){
        let swiftUIView = SwiftUIViewPractice8()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func test209(){
        let userState = UserLoginState()
        let swiftUIView = SwiftUIViewPractice9()
                .environmentObject(userState)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
