//
//  UIView+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/5.
//

import UIKit

extension UIView
{
    /// 设置view的阴影 带圆角
    ///
    /// - Parameters:
    ///   - size: 大小  默认CGSize(width: 0, height: 3)
    ///   - radius: 阴影的模糊半径 默认 4
    ///   - color: 阴影颜色 默认 黑色 0.5
    ///   - opacity: 阴影 渲染 默认1
    ///   - corner: 圆角 默认18
    
    public func makeLayerShadowCorner(size: CGSize = CGSize(width: 0, height: 3), radius: CGFloat = 4, color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), opacity: Float = 1, corner: CGFloat = 18)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.cornerRadius = corner
    }
}
