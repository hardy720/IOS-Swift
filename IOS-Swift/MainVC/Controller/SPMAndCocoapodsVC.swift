//
//  SPMAndCocoapodsVCViewController.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/7.
//

import UIKit

class SPMAndCocoapodsVC: FLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray =
        [
            "一、说明",
            "二、对比"
        ]
        dataArray =
        [
            [
                "SPM 和 CocoaPods 是目前 Swift/iOS 开发中最主流的两个依赖管理工具"
            ],
            [
                "集成方式与用户体验\nSPM\n集成在 Xcode 11+ 中，无需安装任何额外工具。\n添加依赖：图形界面搜索 GitHub 地址，或直接粘贴 URL。\n移除/更新依赖：同样在 Xcode 中可视化操作，自动修改 Package.resolved。\n最大优点：无需离开 Xcode，无需管理额外的工作空间 (xcworkspace)。\nCocoaPods\n需要先安装 Ruby (sudo gem install cocoapods)。\n在项目根目录执行 pod init 生成 Podfile，编辑后运行 pod install。\n之后必须打开 .xcworkspace 而非 .xcodeproj。\n优点：丰富的插件生态（如 cocoapods-rome 打包成二进制）。\n缺点：Ruby 环境可能冲突（尤其是 macOS 系统 Ruby 权限问题）；每次 pod install 会修改工程文件。",
             "依赖解析与版本管理\nSPM\n使用语义化版本控制 (SemVer) 作为默认规则。\n支持范围：upToNextMajor(from:)（~> 等效）、exact、branch、revision。\n解析速度快，但刚性较强：如果两个依赖要求同一个库的不同不兼容版本，SPM 会直接报错，不会自动降级或覆盖。\n优点：强制清晰、无隐式冲突。\n缺点：有时需要开发者手动调整依赖版本。\nCocoaPods\n同样支持语义版本及 Git 分支/提交，但更灵活。\n如果 A 要求库 X ~> 1.0，B 要求 X ~> 1.5，CocoaPods 会尝试取满足两者且较高的版本（如 1.5.3），如果无法满足则尝试降级次依赖。\n优点：自动解决冲突的能力更强，对大型项目更友好。\n缺点：可能产生隐式的版本“强制提升”，导致运行时意外。",
            "资源文件与本地化\nSPM\n从 Swift 5.3 / Xcode 12 开始，通过 Package.swift 中的 resources 选项声明。\n支持 process（自动处理，如图片压缩）和 copy（原样复制）。\n访问：Bundle.module.url(forResource: 'icon', withExtension: 'png')。\n优点：原生、简便，与 Swift 模块完美集成。\nCocoaPods\n需要定义 spec.resource_bundles，会生成一个独立的 bundle。\n访问时需通过 podTargetName.bundle 路径，稍显繁琐。\n优点：支持更多资源类型（如 .storyboard、.xib 可通过 preserve_paths 保留）。",
                "二进制依赖与私有库\nSPM\n支持 .binaryTarget，可以直接引用 .xcframework 或远程 .zip 文件。\n适合集成闭源 SDK（如地图、支付）\n限制：二进制 target 不能有进一步的子依赖（依赖需在同一个二进制 target 内打包好）。\nCocoaPods\n通过 vendored_frameworks 或 vendored_libraries 指定。\n更灵活，可同时包含源码和二进制库，并允许混合依赖。\n对于大型厂商 SDK（如 Firebase、AWS），通常提供 CocoaPods 集成步骤。"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "SPM 和 CocoaPods"
        view.addSubview(tableView)
    }
}
