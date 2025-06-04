//
//  FLWindowManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/9.
//

import UIKit

class FLWindowManager: NSObject
{
    static let shared = FLWindowManager()
    private var currentNavigationController: UINavigationController?
    private(set) var window: UIWindow?
    private override init() 
    {
        super.init()
    }

    func setUpWindow(_ window: UIWindow)
    {
        self.window = window
    }

    func setRootVC()
    {
        let nav = FLBaseNavigationController(rootViewController:self.getRootVC())
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        self.setCurrentNavigationController(nav)
    }
    
    // 提供一个设置当前导航控制器的方法
    func setCurrentNavigationController(_ navigationController: UINavigationController)
    {
        self.currentNavigationController = navigationController
    }
    
    // 提供一个获取当前导航控制器的方法
    func getCurrentNavigationController() -> UINavigationController?
    {
        return currentNavigationController
    }
    
    func getRootVC() -> UIViewController
    {
        let rootVCStr:String = UserDefaults.standard.string(forKey: Appdelegate_RootVC_Key_Str) ?? ""
        var rootVC = UIViewController.init()
        switch rootVCStr {
        case Appdelegate_RootVC_Value_A_Str:
            rootVC = FLLoginViewController.init()
            break
            
        case Appdelegate_RootVC_Value_B_Str:
            rootVC = FLHomeViewController.init()
            break
            
        case "":
            rootVC = FLHomeViewController.init()
            break
            
        case Appdelegate_RootVC_Value_C_Str:
            rootVC = FLChatHomeViewController.init()
            break
            
        default:
            break
        }
        return rootVC
    }
    
    func changeRootVC(vcStr : String)
    {
        UserDefaults.standard.setValue(vcStr, forKey: Appdelegate_RootVC_Key_Str)
        self.setRootVC()
    }
    
    func goToHelloTalk()
    {
        let nav = FLBaseNavigationController(rootViewController:FLHelloTalkViewController.init())
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
    }
}
