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
        self.initNoti()
        self.connectSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(WebSocket_Recived_Message_Noti), object: nil)
    }
    
    func connectSocket()
    {
        FLWebSocketManager.shared.connect()  
    }
    
    func initUI()
    {
        let userModel = FLUserInfoManager.shared.getUserInfo()
        self.title = userModel.userName
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
                self?.perform(#selector(self?.createUser), with: nil, afterDelay: 0.3)
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
    
    @objc func createUser()
    {
        // 创建 UIAlertController 实例
        let alertController = UIAlertController(title: "输入好友昵称", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "请输入内容"
        }
        // 添加确定按钮
        let okAction = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            if let textFields = alertController.textFields, let textField = textFields.first {
                // 获取输入的内容
                let inputText = textField.text ?? "Default Nickname"
        
                let userModel = FLUserModel.init()
                userModel.avatar = String.fl.getRandomImageUrlStr()!
                userModel.userName = inputText
                userModel.passWord = "123456"
                self?.createUserToServer(model: userModel)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func createUserToServer(model: FLUserModel)
    {
        self.view.makeToastActivity(.center)
        let paramDict = [
            "userName":model.userName,
            "avatar":model.avatar,
            "passWord":model.passWord
        ]
        FLNetworkManager.shared.requestData(.post, URLString: "\(BASE_URL)user/addUser", paramaters: paramDict) { response in
            let json = JSON(response)
            let alertMessage = json["msg"].stringValue;
            self.view.hideToastActivity()
            if json["code"].intValue == 200 {
                let dic_info = json["data"]
                let chatListModel = FLChatListModel.init()
                chatListModel.friendAvatar = dic_info["avatar"].stringValue
                chatListModel.friendName = model.userName
                chatListModel.friendId = dic_info["id"].intValue
                let isok = FLChatListDao.init().insertChatListTable(model: chatListModel)
                FLPrint("新增是否成功:\(isok)")
                self.initData()
                self.tableView?.reloadData()
            }
        }
    }
    
    func createChartToServer(model: FLChatListModel)
    {
        let userModel = FLUserInfoManager.shared.getUserInfo()
        let paramDict = [
            "friendName":model.friendName,
            "userId":userModel.id,
            "friendAvatar":model.friendAvatar
        ]
        FLNetworkManager.shared.requestData(.post, URLString: "\(BASE_URL)friendList/addFriend", paramaters: paramDict) { response in
            self.view.hideToastActivity()
            let json = JSON(response)
            let alertMessage = json["msg"].stringValue;
            if json["code"].intValue == 200 {
                
            }
            self.view.makeToast(alertMessage.fl.isStringBlank() ? "检查服务器":alertMessage, duration: 3.0, position: .center)
        }
    }
    
    func creatUserInfo()
    {
        
    }
    
    func initData()
    {
        dataArr = FLChatListDao.init().fetchChatListTable() ?? []
    }
    
    @objc func handleWebSocketMessage(_ notification: Notification) 
    {
        if let userInfo = notification.userInfo, let messageDict = userInfo["message"] as? [String: Any] {
            if let chartType = messageDict["chart_Type"] as? Int {
                // 处理接收到的消息
                FLPrint("Received message in ViewController: msg_Type=\(chartType)")
                switch chartType {
                case 0:
                    // 心跳
                    break;
                case 1:
                    // 单聊
                    if let chartAvatar = messageDict["chart_Avatar"] as? String, let userName = messageDict["user_Name"] as? String, let data = messageDict["data"] as? String, let msg_From_id = messageDict["msg_From"] as? String,
                       let msg_type = messageDict["msg_Type"] as? Int
                    {
                        let chatListModel = FLChatListModel.init()
                        chatListModel.friendAvatar = chartAvatar
                        chatListModel.friendName = userName
                        if msg_type == 2 {
                            chatListModel.lastText = "[图片]"
                        }else{
                            chatListModel.lastText = data
                        }
                        let getMsgListModel = FLChatListDao.init().fetchChatByFriendID(friendID: Int(msg_From_id)!)

                        chatListModel.friendId = Int(msg_From_id)!
                        chatListModel.messageAlert = (getMsgListModel?.messageAlert ?? 0) + 1
                        let isok = FLChatListDao.init().insertChatListTable(model: chatListModel)
                        
                        if !FLDatabaseManager.shared.tableExists(tableName: "\(chatDetailTableName)\(msg_From_id)") {
                            FLDatabaseManager.shared.createChat(userID: "\(msg_From_id)")
                        }
                        let model = FLChatMsgModel.init()
                        model.contentStr = data
                        model.msgType = FLMessageType(rawValue: msg_type) ?? .msg_unknown
                        model.isMe = false
                        model.avatar = chartAvatar
                        model.nickName = userName
                        if msg_type == 2, let msg_img_height = messageDict["msg_img_height"] as? Int, let msg_img_weight = messageDict["msg_img_weight"] as? Int {
                            model.imgWidth = msg_img_weight
                            model.imgHeight = msg_img_height
                        }
                        _ = FLChatDetailDao.init().insertChatListTable(chatID: msg_From_id, model: model)
                        
                        FLPrint("新增是否成功:\(isok)")
                        self.initData()
                        self.tableView?.reloadData()
                    }
                   
                    break;
                default:
                    break;
                }
            }
        }
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
            let isOk1 = FLChatDetailDao.init().dropChat(chatTableName: "\(chatDetailTableName)\(model.friendId)")
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
        if !FLDatabaseManager.shared.tableExists(tableName: "\(chatDetailTableName)\(model.friendId)") {
            FLDatabaseManager.shared.createChat(userID: "\(model.friendId)")
        }
        chatDetailVC.chatModel = model
        chatDetailVC.completion = { [weak self] in
            self?.initData()
            self?.tableView?.reloadData()
        }
        self.navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}


// MARK: - Test -
extension FLChatHomeViewController
{
    func test1()
    {
        let userModel = FLUserInfoManager.shared.getUserInfo()
        let nameLabel = UILabel.init(frame: CGRect(x: Int(screenW())/2 - 50, y: Int(screenH())/2 - 50, width: 100, height: 100))
        nameLabel.text = userModel.userName
        nameLabel.backgroundColor = .red
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
    }
}


// MARK: - 通知管理 -
extension FLChatHomeViewController
{
    func initNoti()
    {
        // 获得socket通讯数据
        NotificationCenter.default.addObserver(self, selector: #selector(handleWebSocketMessage(_:)), name: Notification.Name(WebSocket_Recived_Message_Noti), object: nil)
    }
}
