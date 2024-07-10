//
//  FLBaseNavigationController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

class FLBaseNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setNavBackColor()
    }
    
    func setNavBackColor() {
        // 设置导航栏背景颜色
        let navbarTintColor = UIColor.FLGlobalColor()
        // iOS 15后，需要手动设置UINavigationBar的scrollEdgeAppearance和standardAppearance属性才行
        if #available(iOS 13, *) {
            // 处于顶部时的背景
            let scrollEdgeAppearance = UINavigationBarAppearance()
            scrollEdgeAppearance.backgroundColor = navbarTintColor
            navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            // 滑动后的背景
            let standardAppearance = UINavigationBarAppearance()
            standardAppearance.backgroundColor = navbarTintColor
            navigationBar.standardAppearance = standardAppearance
            // 不设置任何属性则是默认的毛玻璃效果
        } else {
            navigationBar.barTintColor = navbarTintColor
        }
        let dict: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        // 标题颜色
        navigationBar.titleTextAttributes = dict
        // item颜色
        navigationBar.tintColor = UIColor.black
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
