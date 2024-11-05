//
//  FLChatHomeViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/8/22.
//

import UIKit
import SwiftyJSON

class FLChatHomeViewController: UIViewController
{
    static let cellID : String = "ChatListId"
    
    var dataArr: [FLChatListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
        self.connectSocket()
    }
    
    func connectSocket()
    {
        FLWebSocketManager.shared.connect()  
    }
    
    func initUI()
    {
        self.title = "聊天"
        view.backgroundColor = .white
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "icon_more_add"), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(tableView!)
    }
    
    @objc func showPopMenu(_ item: UIBarButtonItem)
    {
        var testStr = ""
        if UserDefaults.standard.bool(forKey: Test_Test_IsOpen)   {
            testStr = Test_Test_CloseTest
        }else{
            testStr = Test_Test_OpenTest
        }
        let popData = [(icon:"icon_chat_switch",title:Appdelegate_HomeVC_SwitchStatus), (icon:"icon_chat_chat",title:Chat_ChatHome_NewChat),
            (icon:"test_test_test",title:testStr),
            (icon:"icon_chat_home_loginout"
            ,title:Chat_ChatHome_LoginOut)]
        let parameters:[FLPopMenuConfigure] =
        [
            .PopMenuTextColor(UIColor.black),
            .popMenuItemHeight(44),
            .PopMenuTextFont(UIFont.systemFont(ofSize: 18))
        ]
        let popMenu = FLPopMenu(menuWidth: 150, arrow: CGPoint(x: screenW() - 25, y: fNavigaH), datas: popData,configures: parameters)
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            switch index {
            case 0:
                FLWindowManager.shared.changeRootVC(vcStr: Appdelegate_RootVC_Value_B_Str)
                break
            
            case 1:
                let model = FLChatListModel.init()
                model.friendAvatar = String.fl.getRandomImageUrlStr()!
                model.friendName = "用户-00\(self!.dataArr.count)"
                model.lastText = "我是最后一句"
                let isok = FLChatListDao.init().insertChatListTable(model: model)
                FLPrint("新增是否成功:\(isok)")
                self?.initData()
                self?.tableView?.reloadData()
                self?.createChartToServer(model: model)
                break
            
            case 2:
                UserDefaults.standard.bool(forKey: Test_Test_IsOpen) ? UserDefaults.standard.setValue(false, forKey: Test_Test_IsOpen) : UserDefaults.standard.setValue(true, forKey: Test_Test_IsOpen)
                break
                
            case 3:
                FLWindowManager.shared.changeRootVC(vcStr: Appdelegate_RootVC_Value_A_Str)
                break
                
            default:
                break
            }
        }
        popMenu.show()
    }
    
    func createChartToServer(model: FLChatListModel)
    {
        let userModel = FLUserInfoManager.shared.getUserInfo()
        let paramDict = [
            "friendName":model.friendName,
            "userId":userModel.id,
            "friendAvatar":model.friendAvatar
        ]
        self.view.makeToastActivity(.center)
        FLNetworkManager.shared.requestData(.post, URLString: "\(BASE_URL)friendList/addFriend", paramaters: paramDict) { response in
            self.view.hideToastActivity()
            let json = JSON(response)
            let alertMessage = json["msg"].stringValue;
            if json["code"].intValue == 200 {
            }
            self.view.makeToast(alertMessage.fl.isStringBlank() ? "检查服务器":alertMessage, duration: 3.0, position: .center)
        }
    }
    
    func initData()
    {
        dataArr = FLChatListDao.init().fetchChatListTable() ?? []
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH()), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FLChatListTableViewCell.classForCoder(), forCellReuseIdentifier: FLChatHomeViewController.cellID)
        tableView.rowHeight = 75
        tableView.backgroundColor = .white
        return tableView
    }()
}

extension FLChatHomeViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: FLChatHomeViewController.cellID) as! FLChatListTableViewCell
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
            let isOk = FLChatListDao.init().deleteChatListTable(id: model.id)
            FLPrint("删除是否成功:%d",isOk)
            dataArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
        let model = dataArr[indexPath.row]
        let chatDetailVC = FLChatDetailVC.init()
        FLDatabaseManager.shared.createChat(userID: "\(model.id)")
        chatDetailVC.chatModel = model
        self.navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}
