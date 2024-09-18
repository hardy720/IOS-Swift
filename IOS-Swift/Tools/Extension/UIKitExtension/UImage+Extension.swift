//
//  UImage+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/16.
//

import UIKit

extension UIImage
{
    /**
     * capInsets 是用来指定哪些边缘区域不被拉伸，而中间区域则会被拉伸以填充额外的空间
     */
    func resizableImageWithCenteredStretch(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIImage
    {
        let capInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
