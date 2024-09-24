//
//  UImage+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/16.
//

import UIKit

extension UIImage
{
    /// 图片点九处理
    /// - Parameter sscale: 比例
    func stretchableImage(centerStretchScale sscale:CGFloat) -> UIImage {
        let top = self.size.height - 8;
        let left = self.size.width / 2 - 2;
        let right = self.size.width / 2 + 2;
        let bottom = self.size.height - 4;
        return self.resizableImage(withCapInsets: UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right), resizingMode: .stretch)
    }
}
