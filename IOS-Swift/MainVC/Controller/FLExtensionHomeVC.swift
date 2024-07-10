//
//  FLExtensionHomeVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/9.
//

import UIKit

class FLExtensionHomeVC: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setData()
    }
    
    func setData() {
        self.title = "Extension"
        dataArray = ["FoundationExtension","UIKitExtension"]
        delegate = self
    }
    
    func didSelectCell(at indexPath: IndexPath) {
//        FLPrint("Cell at \(indexPath.row) selected")
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(FLFoundationExtensionVC.init(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(FLUIKitExtensionVC.init(), animated: true)
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
