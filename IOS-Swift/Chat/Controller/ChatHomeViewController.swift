//
//  ChatHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class ChatHomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initUI()
    }
    
    func initUI()
    {
        self.title = "聊天"
        view.backgroundColor = .white
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_more_add"), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func showPopMenu(_ item: UIBarButtonItem)
    {
        let popData = [(icon:"icon_chat_switch",title:"切换状态"), (icon:"icon_chat_chat",title:"单聊"), (icon:"icon_chat_scan",title:"扫一扫")]
        let parameters:[FLPopMenuConfigure] =
        [
            .PopMenuTextColor(UIColor.black),
            .popMenuItemHeight(44),
            .PopMenuTextFont(UIFont.systemFont(ofSize: 18))
        ]
        let popMenu = FLPopMenu(menuWidth: 150, arrow: CGPoint(x: screenW() - 25, y: fNavigaH), datas: popData,configures: parameters)
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            if index == 0 {
                WindowManager.shared.changeRootVC();
            }
        }
        popMenu.show()
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH()), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "12", for: indexPath) as! UITableViewCell
        return cell
    }
}
