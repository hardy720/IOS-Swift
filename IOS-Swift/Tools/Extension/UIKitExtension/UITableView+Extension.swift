//
//  UITableView+Extension.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/24.
//

import Foundation
import UIKit

public extension UITableView 
{
    func scrollToLast(at scrollPosition: UITableView.ScrollPosition, animated: Bool) 
    {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: 0) > 0 else { return }
        let lastIndexPath = IndexPath(item: numberOfRows(inSection: lastSection)-1, section: lastSection)
        scrollToRow(at: lastIndexPath, at: scrollPosition, animated: animated)
    }
}
