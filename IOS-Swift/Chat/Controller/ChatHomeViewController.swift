//
//  ChatHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit

class ChatHomeViewController: UIViewController {
    
    static let cellID : String = "ChatListId"
    
    var dataArr: [ChatListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
    }
    
    func initUI()
    {
        self.title = "聊天"
        view.backgroundColor = .white
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_more_add"), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(self.tableView!)
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
            if index == 1 {
                let model = ChatListModel.init()
                model.avatar = String.fl.getRandomImageUrlStr()!
                model.nickName = "用户-00\(self!.dataArr.count)"
                model.lastContent = "我是最后一句"
                let isok = ChatListDao.init().insertChatListTable(model: model)
                FLPrint("新增是否成功:\(isok)")
                self?.initData()
                self?.tableView?.reloadData()
            }
        }
        popMenu.show()
    }
    
    func initData()
    {
        dataArr = ChatListDao.init().fetchChatListTable() ?? []
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH()), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListTableViewCell.classForCoder(), forCellReuseIdentifier: ChatHomeViewController.cellID)
        tableView.rowHeight = 70
        return tableView
    }()
}

extension ChatHomeViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatHomeViewController.cellID) as! ChatListTableViewCell
        let model = dataArr[indexPath.row]
        cell.setModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) 
    {
            if editingStyle == .delete {
                let model = dataArr[indexPath.row]
                let isOk = ChatListDao.init().deleteChatListTable(id: model.id)
                dataArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
            }
        }
}
