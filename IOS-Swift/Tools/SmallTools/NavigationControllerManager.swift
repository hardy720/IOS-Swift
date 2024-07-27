//
//  NavigationControllerManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/26.
//

import Foundation
import UIKit

class NavigationControllerManager
{
    static let shared = NavigationControllerManager()
    private var currentNavigationController: UINavigationController?
    private init() {}
    // 提供一个设置当前导航控制器的方法
    func setCurrentNavigationController(_ navigationController: UINavigationController) {
        self.currentNavigationController = navigationController
    }
    // 提供一个获取当前导航控制器的方法
    func getCurrentNavigationController() -> UINavigationController? {
        return currentNavigationController
    }
}
