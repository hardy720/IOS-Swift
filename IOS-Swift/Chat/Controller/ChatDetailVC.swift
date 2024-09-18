//
//  ChatDetailVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/10.
//

import UIKit

class ChatDetailVC: UIViewController 
{
    var chatModel : FLChatListModel? = nil
    var dataArr: [FLChatMsgModel] = []
    static let cellID_type_text : String = "Chat_Detail_CellID_Text"

    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        self.initData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initData()
    {
//        let model = FLChatMsgModel.init()
//        model.avatar = "123"
//        model.nickName = "222"
//        model.avatar = chatModel?.avatar ?? ""
//        model.contentStr = "水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发水力发电九分裤算法设计绿卡的飞机落实贷款解放东路福建师大饭卡老大飞机上离开的封建势力咖啡机双打卡理发老地方快结束了咖啡机苏卡达理发手机大发"
//        model.lastContent = "sfsfl雷锋精神看到了"
//        model.msgType = .msg_text
//        model.isMe = true
//        ChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        
        print(ChatDetailDao.init().fetchChatDetailTable(userID: "\(chatModel!.id)"))
        
        dataArr = ChatDetailDao.init().fetchChatDetailTable(userID: "\(chatModel!.id)")!
        print(dataArr)
        
        if !self.dataArr.isEmpty {
            let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.tableView!.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func initUI()
    {
        view.backgroundColor = .white
        self.title = chatModel?.nickName
        view.addSubview(tableView!)
        view.addSubview(FLCustomKeyboardView.init(frame: CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height, width: screenW(), height: Chat_Custom_Keyboard_Height)))
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH() - Chat_Custom_Keyboard_Height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatTextMessageCell.classForCoder(), forCellReuseIdentifier: ChatDetailVC.cellID_type_text)
        tableView.rowHeight = 75
        tableView.backgroundColor = Chat_Cell_Background_Gray
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension ChatDetailVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = dataArr[indexPath.row]
        switch model.msgType {
        case .msg_text:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatDetailVC.cellID_type_text, for: indexPath) as! ChatTextMessageCell
            cell.setModel(with: model)
            return cell
            
        default:
            let placeholderCell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCellIdentifier", for: indexPath)
            return placeholderCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat 
    {
        var height : CGFloat = 0.0
        let model = dataArr[indexPath.row]
        switch model.msgType {
        case .msg_text: 
            let size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(chart_cell_text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))
            height = size.height + 50
            break
            
        default:
            
            break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
        
    }
}
