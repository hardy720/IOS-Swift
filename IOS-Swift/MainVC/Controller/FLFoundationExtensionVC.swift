//
//  FLFoundationExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/9.
//

import UIKit

class FLFoundationExtensionVC: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
        self.initUI()
    }
    
    func initUI() {
        self.title = "FoundationExtension"
        view.addSubview(tableView)
    }
    
    func setData() {
        dataArray = ["Array+Extension", "CGPoint+Extension", "DispatchQueue+Extension", "NumberFormatter+Extension", "CLLocation+Extension", "NSRange+Extension", "Range+Extension", "AVAssetExportSession+Extension", "NSIndexPath+Extension", "Bundle+Extension", "UserDefaults+Extension", "Date+Extension", "NSObject+Extension", "String+Extension", "UIDevice+Extension", "UIFont+Extension", "Timer+Extension", "Int+Extension", "Double+Extension", "UInt+Extension", "Int64+Extension", "Float+Extension", "Data+Extension", "Bool+Extension", "CGFloat+Extension", "Character+Extension", "DateFormatter+Extension", "Dictionary+Extension", "FileManager+Extension", "URL+Extension", "NSDecimalNumberHandler+Extension", "NSAttributedString+Extension", "NSMutableAttributedString+Extension"]
        delegate = self
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(FLArrayExtensionVC.init(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(CGPointExtensionVC.init(), animated: true)
            break
        default:
            break
        }
    }
}
