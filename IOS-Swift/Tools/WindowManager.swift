//
//  WindowManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/9.
//

import UIKit

class WindowManager: NSObject 
{
    static let shared = WindowManager()
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
        if rootVCStr == Appdelegate_RootVC_Value_A_Str {
            rootVC = ChatHomeViewController.init()
        }
        if rootVCStr == Appdelegate_RootVC_Value_B_Str || rootVCStr.fl.isStringBlank() {
            rootVC = FLHomeViewController.init()
        }
        return rootVC
    }
    
    func changeRootVC()
    {
        let rootVCStr = UserDefaults.standard.string(forKey: Appdelegate_RootVC_Key_Str) ?? ""
        if rootVCStr == Appdelegate_RootVC_Value_A_Str {
            UserDefaults.standard.setValue(Appdelegate_RootVC_Value_B_Str, forKey: Appdelegate_RootVC_Key_Str)
        }
        if rootVCStr == Appdelegate_RootVC_Value_B_Str || rootVCStr.fl.isStringBlank() {
            UserDefaults.standard.setValue(Appdelegate_RootVC_Value_A_Str, forKey: Appdelegate_RootVC_Key_Str)
        }
        self.setRootVC()
    }
}
