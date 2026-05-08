//
//  SwiftyJSONViewController.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/7.
//

import UIKit
import SwiftyJSON

class SwiftyJSONViewController: FLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initUI()
    {
        self.title = "SwiftyJSON"
        view.addSubview(tableView)
    }
    
    func initData()
    {
        headDataArray =
        [
            "第一阶段：SwiftyJSON基础用法",
            "第二阶段：进阶技巧（安全取值 + 错误处理）",
            "第三阶段：更好的错误处理实践",
            "高阶实践：模拟“用户列表及帖子”场景",
            "进阶思考：SwiftyJSON源码设计亮点"
        ]
        
        dataArray =
        [
            ["在第一阶段，我们主要学习如何创建JSON对象以及访问JSON中的简单数据。SwiftyJSON的使用可以概括为三步走：导入 → 创建对象 → 通过下标访问值","例子1：从Data创建JSON对象并取值\n例子2：访问嵌套属性和数组（链式调用）"],
            ["基础访问有个小小的风险：如果JSON格式不符合预期，应用程序可能会崩溃。SwiftyJSON提供了多种方式来安全地访问值，确保代码在面对不完整的JSON时依然稳健\n例子1：使用.string/.int（返可选值）\n例子2：提供默认值（stringValue系列）\n例子3：检测Key是否存在及类型判断\n在生产环境中，我们可能需要在解析之前先确定JSON结构和类型是否符合预期，以便给出错误提示或降级处理。SwiftyJSON提供了exists()和type属性"],
            [
                "当JSON来自第三方API时，你很可能遇到各种不可控的情况（如格式错误、字段缺失）。下面介绍SwiftyJSON内置的错误反馈机制。",
                "捕获JSON初始化错误\n初始化JSON对象时，如果传入非法JSON字符串，可能会抛出异常，这时将JSON对象的构造过程用do-catch框起来，就能捕获到明确的具体错误",
                "使用error属性追踪访问错误\n当访问不存在的下标时，SwiftyJSON不会崩溃，但可以用.error来检查具体发生的异常（如越界、类型不符等）\n相比于直接访问可能越界的数组，这种方式可捕获具体错误类型，便于后续给用户友好的提醒。",
                "主动验证完整结构\n许多现实中的API会不定时删减字段或改变类型，因此官方推荐在正式解析前先验证主要结构"
            ],
            [
                "为了综合运用SwiftyJSON的各种技巧，我们构造一个包含用户及他们发布帖子的模拟数据，并演示从解析到展示的完整环节。",
                "Step 1：模拟复杂JSON数据\nStep 2：分步解析\nStep 3：运行结果分析"
            ],
            [
                "以枚举包装JSON数据类型\nSwiftyJSON内部用enum Type来表示JSON的语义类型（如.string、.number、.array等），通过switch动态分发取值路径，这极大地保证了存取时的类型安全",
                "下标（subscript）的妙用\nSwiftyJSON定义了大量subscript重载方法，使得不管你传入字符串下标还是整数下标（比如json[0]['user']），都能优雅地返回一个JSON对象，支持无限层级链式调用。",
                "一套默认值协议\nExpressibleByStringLiteral等协议的实现使得我们可以直接用let json: JSON = ['name':'value']创建JSON对象，符合Swift的语言直觉和生态。"
            ]
        ]
    }
}

extension SwiftyJSONViewController {
    @objc func test102() {
        test102_1()
        test102_2()
    }
    
    @objc func test201() {
        test201_0()
        test201_1()
        test201_2()
    }
    
    @objc func test302() {
        test302_1()
    }
    
    @objc func test303() {
        test303_1()
    }
    
    @objc func test304() {
        
    }
    
    @objc func test402() {
        test402_1()
    }
}

extension SwiftyJSONViewController {
    
    // 辅助函数：将JSON字符串转为Data，便于练习
    func dataFromJsonString(_ jsonString: String) -> Data {
        return jsonString.data(using: .utf8)!
    }
    
    func test402_1(){
        let jsonString = """
        {
            "code": 200,
            "message": "success",
            "data": {
                "total": 2,
                "users": [
                    {
                        "id": 101,
                        "name": "李雷",
                        "profile": {
                            "avatar": "https://example.com/avatar1.png",
                            "bio": "Swift爱好者"
                        },
                        "posts": [
                            { "id": 1001, "title": "SwiftyJSON学习笔记", "likes": 120 },
                            { "id": 1002, "title": "深入理解Swift可选链", "likes": 95 }
                        ]
                    },
                    {
                        "id": 102,
                        "name": "韩梅梅",
                        "profile": {
                            "avatar": "https://example.com/avatar2.png",
                            "bio": "iOS开发工程师"
                        },
                        "posts": [
                            { "id": 2001, "title": "iOS架构浅谈", "likes": 210 }
                        ]
                    }
                ]
            }
        }
        """
        do {
            let json = try JSON(data: jsonString.data(using: .utf8)!)
            // 1. 外层结构验证
            guard json["code"].int == 200 else {
                FLPrint("API错误：\(json["message"].stringValue)")
                return
            }

            // 2. 安全提取总用户数
            let totalUsers = json["data"]["total"].intValue

            // 3. 遍历用户数组
            if let users = json["data"]["users"].array {        // 使用.array获取可选数组
                for user in users {
                    let id = user["id"].intValue
                    let name = user["name"].stringValue
                    
                    // 嵌套信息：用户资料
                    let avatar = user["profile"]["avatar"].stringValue
                    let bio = user["profile"]["bio"].stringValue
                    
                    FLPrint("用户：\(name)（ID: \(id)）")
                    FLPrint("    头像：\(avatar)")
                    FLPrint("    简介：\(bio)")
                    
                    // 遍历该用户的帖子
                    if let posts = user["posts"].array {
                        for post in posts {
                            let title = post["title"].stringValue
                            let likes = post["likes"].intValue
                            FLPrint("    帖子：《\(title)》，点赞数：\(likes)")
                        }
                    }
                    FLPrint("---")
                }
            }
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test304_1(){
        let jsonString = """
        {
            "products": ["手机", "电脑"]
        }
        """
        do {
            let json = try JSON(data: jsonString.data(using: .utf8)!)
            guard json["user"]["userID"].exists() && json["user"]["userID"].type == .string else {
                throw SwiftyJSONError.wrongType
            }
            let id = json["user"]["userID"].stringValue
            
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test303_1() {
        let jsonString = """
        {
            "products": ["手机", "电脑"]
        }
        """
        do {
            let json = try JSON(data: dataFromJsonString(jsonString))
            let thirdProduct = json["products"][2]  // 下标 2 越界
            if let error = thirdProduct.error {
                FLPrint("访问出错: \(error)")          // indexOutOfBounds
            }
            FLPrint(json)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test302_1() {
        let malformedJSON = "{ name: '张三'," // 缺少双引号和括号闭合
        do {
            let json = try JSON(data: malformedJSON.data(using: .utf8)!)
            FLPrint(json)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test201_2() {
        let jsonString = """
        {
            "name": "张三"
        }
        """
        do {
            let json = try JSON(data: dataFromJsonString(jsonString))
            if json["address"]["city"].exists() {
                FLPrint("存在")
            } else {
                FLPrint("不存在")
            }
            if json["age"].type == .number {
                let ageNum = json["age"].intValue
                FLPrint(ageNum)
            } else {
                FLPrint("类型不匹配")
            }
        }catch{
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test201_1() {
        let jsonString = """
        {
            "name": "张三"
        }
        """
        do {
            let json = try JSON(data: dataFromJsonString(jsonString))
            let defaultName = json["name"].stringValue          // "张三"
            let defaultAge = json["age"].intValue               // 0（缺失键的默认值）
            let defaultCountry = json["country"].stringValue    // ""（缺失键的默认值）
            FLPrint(defaultName,defaultAge,defaultCountry)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    func test201_0() {
        let jsonString = """
        {
            "name": "张三"
        }
        """
        do {
            let json = try JSON(data: dataFromJsonString(jsonString))
            let name = json["name"].stringValue
            let age = json["age"].int                  // nil（键缺失）
            let country = json["country"].string
            FLPrint(name,age as Any,country as Any)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test102_1 (){
        let jsonString =
        """
        {
            "name": "张三",
            "age": 25,
            "email": "zhangsan@example.com"
        }
        """
        let data = dataFromJsonString(jsonString)
        do {
            let json = try JSON(data: data)
            let name = json["name"].stringValue
            FLPrint(name)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
    
    func test102_2 (){
        let jsonString = """
        {
            "school": "XX大学",
            "address": {
                "city": "北京",
                "district": "海淀区"
            },
            "scores": [98, 87, 91, 95]
        }
        """
                
        do {
            let json = try JSON(data: dataFromJsonString(jsonString))
            let city = json["address"]["city"].stringValue          // 访问嵌套属性: "北京"
            let secondScore = json["scores"][1].intValue
            FLPrint(city,secondScore)
        } catch {
            FLPrint("解析错误: \(error)")
        }
    }
}
