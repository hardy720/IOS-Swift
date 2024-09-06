//
//  ChatHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class ChatHomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, FLPopListMenuDelegate {
    
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
        let rightBarButtonItem1 = UIBarButtonItem(image: UIImage.init(named: "icon_more_add"), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItems = [rightBarButtonItem,rightBarButtonItem1]
//        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 60, height: 100)
        button.backgroundColor = .green
        button.setTitle("标题", for: .normal)
        button.addTarget(self, action: #selector(showPopMenu), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func showPopMenu()
    {
        let popView = FLNavPopuListMenu(dataSource: menuList)
        popView.delegate = self
        popView.show()
    }
    
    private lazy var menuList: [FLCellDataConfig] = {
        let items = [
            FLCellDataConfig(title: "切换状态", image: "icon_chat_switch", isShow: true),
            FLCellDataConfig(title: "发起群聊", image: "icon_chat_chat", isShow: true),
            FLCellDataConfig(title: "扫一扫", image: "icon_chat_scan", isShow: false)
        ]
        return items
    }()
    
    func menu(_ model: FLCellDataConfig, didSelectRowAt index: Int)
    {
        
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
