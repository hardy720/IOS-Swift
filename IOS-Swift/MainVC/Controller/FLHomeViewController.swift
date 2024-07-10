//
//  FLHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

class FLHomeViewController: FLBaseViewController, FLBaseViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
        self.initData()
        let ss = Date.fl.secondStamp
//        let year = Date.fl.year
    }
    
    private func initUI()
    {
        self.title = "IOS-Swift"
    }
    
    private func initData()
    {
        delegate = self
        dataArray = ["Extension","SmallTools"];
    }
    
    func didSelectCell(at indexPath: IndexPath) {
//        FLPrint("Cell at \(indexPath.row) selected")
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(FLExtensionHomeVC.init(), animated: true)
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

