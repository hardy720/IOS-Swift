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
        self.initData()
        self.initUI()
        self.Test1()
    }
    
    private func initUI()
    {
        self.title = "IOS-Swift"
        view.addSubview(tableView)
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_more_add"), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func showPopMenu(_ item: UIBarButtonItem)
    {
        let popData = [(icon:"icon_chat_switch",title:Appdelegate_HomeVC_SwitchStatus),(icon:"icon_chat_switch",title:Appdelegate_HomeVC_HelloTalk)]
        let parameters:[FLPopMenuConfigure] =
        [
            .PopMenuTextColor(UIColor.black),
            .popMenuItemHeight(44),
            .PopMenuTextFont(UIFont.systemFont(ofSize: 18))
        ]
        let popMenu = FLPopMenu(menuWidth: 150, arrow: CGPoint(x: screenW() - 25, y: fNavigaH), datas: popData,configures: parameters)
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            if index == 0 {
                let isLogin = UserDefaults.standard.bool(forKey: Appdelegate_RootVC_IsLogin_Str)
                if isLogin {
                    FLWindowManager.shared.changeRootVC(vcStr: Appdelegate_RootVC_Value_C_Str)
                } else {
                    FLWindowManager.shared.changeRootVC(vcStr: Appdelegate_RootVC_Value_A_Str)
                }
            }
            if index == 1 {
                FLWindowManager.shared.goToHelloTalk()
            }
        }
        popMenu.show()
    }
    
    private func initData()
    {
        delegate = self
        dataArray = ["Extension","Summary","LibraryStudy","SwiftUI","Test"];
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(FLExtensionHomeVC.init(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(SummaryHomeVC.init(), animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(LibraryHomeViewController.init(), animated: true)
            break
        case 3:
            self.navigationController?.pushViewController(FLSwiftUIViewController.init(), animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(FlTestViewController.init(), animated: true)
            break
        default:
            break
        }
    }
}

extension FLHomeViewController
{
    func Test1() {
        
    }
}

