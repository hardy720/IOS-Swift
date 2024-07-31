//
//  LibraryHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/31.
//

import UIKit

class LibraryHomeViewController: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        delegate = self
        dataArray =
        [
            "Kingfisher"
        ]
    }
    
    func initUI()
    {
        self.title = "Libray"
        view.addSubview(tableView)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(KingfisherViewController.init(), animated: true)
            break
        default:
            break
        }
    }
}
