//
//  FLUIKitExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/9.
//

import UIKit

class FLUIKitExtensionVC: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
    }
    
    func setData() {
        self.title = "UIKitExtension"
        dataArray = ["UITabBarController+Extension", "WKWebView+Extension", "CAGradientLayer+Extension", "UITabbar+Extension", "UIView+Extension", "UITableViewCell+Extension", "UISlider+Extension", "UICollectionView+Extension", "UINavigationBar+Extension", "CALayer+Extension", "CATextLayer+Extension", "UIAlertController+Extension", "UIApplication+Extension", "UIBarButtonItem+Extension", "UIBezierPath+Extension", "UIButton+Extension", "UIControl+Extension", "UIImage+Extension", "UIImageView+Extension", "UILabel+Extension", "UINavigationController+Extension", "UIColor+Extension", "UIScreen+Extension", "UIScrollView+Extension", "UIStackView+Extension", "UISwitch+Extension", "UITableView+Extension", "UITextField+Extension", "UITextView+Extension", "UIViewController+Extension", "UIVisualEffectView+Extension"]
        delegate = self
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        print("Cell at \(indexPath.row) selected")
        switch indexPath.row {
        case 0:
            break
        default:
            break
        }
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
