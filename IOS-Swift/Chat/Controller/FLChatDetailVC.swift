//
//  ChatDetailVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/10.
//

import UIKit

class FLChatDetailVC: UIViewController
{
    var chatModel : FLChatListModel? = nil
    private var dataArr: [FLChatMsgModel] = []
    private static let cellID_type_text : String = "Chat_Detail_CellID_Text"
    private var customKeyboardView : FLCustomKeyboardView? = nil
    private var lastContentOffset: CGFloat = 0.0
    private var isShowKeyboard : Bool = false
    private var keyboardHeight : CGFloat = 0
    private var isSended: Bool = true
    
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
        self.initNoti()
    }
    
    func initData()
    {
        dataArr = ChatDetailDao.init().fetchChatDetailTable(userID: "\(chatModel!.id)")!
        print(dataArr)
        
        test()
        
        cellScrollToBottom()
    }

    func test()
    {
        let model = FLChatMsgModel.init()
        model.nickName = getUserNickName()
        model.avatar = chatModel!.avatar
        model.contentStr = "砥砺奋进都发了快点放假,浪费地脚螺栓咖啡机，打开了福建师范冷风机。翻到了咖啡机佛IE我i哦额我饿加热机。佛法丢哦i我饿金额王老吉方法打撒。简单说了附加费独守空房垃圾了扩大飞机索拉卡发撒登记卡飞拉达生发剂失蜡法金卡拉萨剪发卡电极法手打。这两款的角度看水力发电激发说法@fdlfjfksld收到发快递"
        model.msgType = .msg_text
        model.isMe = false
        let isOk = ChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        dataArr.append(model)
    }
    
    func initUI()
    {
        view.backgroundColor = .white
        self.title = chatModel?.nickName
        view.addSubview(tableView!)
        customKeyboardView = FLCustomKeyboardView.init(frame: CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom, width: screenW(), height: Chat_Custom_Keyboard_Height))
        customKeyboardView?.delegate = self
        view.addSubview(customKeyboardView!)
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatTextMessageCell.classForCoder(), forCellReuseIdentifier: FLChatDetailVC.cellID_type_text)
        tableView.rowHeight = 75
        tableView.backgroundColor = Chat_Cell_Background_Gray
        tableView.separatorStyle = .none
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap))
        tap.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tap)
        return tableView
    }()
}

// MARK: - 工具
extension FLChatDetailVC
{
    // tableviewCell 滚动到最后
    func cellScrollToBottom()
    {
        if !self.dataArr.isEmpty {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
                self.tableView!.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

// MARK: - 按钮事件 -
extension FLChatDetailVC
{
    @objc func tableViewTap()
    {
        if isShowKeyboard {
            self.view.endEditing(true)
        }
    }
}

// MARK: - 通知管理 -
extension FLChatDetailVC
{
    func initNoti()
    {
        // 注册键盘显示通知
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        // 注册键盘隐藏通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            customKeyboardView?.frame.origin.y = screenH() - keyboardHeight - Chat_Custom_Keyboard_Height
            tableView?.frame = CGRectMake(0, 0, screenW(), screenH() - keyboardHeight - Chat_Custom_Keyboard_Height)
            cellScrollToBottom()
        }
        isShowKeyboard = true
        self.isSended = true
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification)
    {
        customKeyboardView?.frame.origin.y = screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom
        tableView?.frame = CGRect(x: 0, y: 0, width: screenW(), height: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom)
        cellScrollToBottom()
        isShowKeyboard = false
    }
}

// MARK: - delegate
extension FLChatDetailVC : UITableViewDataSource,UITableViewDelegate,FLCustomKeyboardViewDelegate
{
    /**
     * tableViewDelegate
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = dataArr[indexPath.row]
        switch model.msgType {
        case .msg_text:
            let cell = tableView.dequeueReusableCell(withIdentifier: FLChatDetailVC.cellID_type_text, for: indexPath) as! ChatTextMessageCell
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
            let size = model.contentStr.fl.rectSize(font: UIFont.systemFont(ofSize: CGFloat(Chart_Cell_Text_font)), size: CGSize(width: Chat_Cell_Text_Width, height: CGFloat(MAXFLOAT)))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) 
    {
        if isSended {
            return
        }
        let currentOffset = scrollView.contentOffset.y
        if lastContentOffset < currentOffset {
            // 向下滚动
        } else if lastContentOffset > currentOffset {
            // 向上滚动
            if isShowKeyboard {
                self.view.endEditing(true)
            }
        }
        lastContentOffset = currentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if isSended {
            isSended = false
        }
    }
    
    // 发送文字消息
    func didChangeText(_ text: String)
    {
        if !text.fl.isStringBlank() {
            let model = FLChatMsgModel.init()
            model.nickName = getUserNickName()
            model.avatar = getUserAvatar()
            model.contentStr = text
            model.msgType = .msg_text
            model.isMe = true
            let isOk = ChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
            dataArr.append(model)
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
                self.tableView?.beginUpdates()
                self.tableView?.insertRows(at: [indexPath], with: .bottom)
                self.tableView?.endUpdates()
            }
            cellScrollToBottom()
            customKeyboardView?.frame = CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom - keyboardHeight, width: screenW(), height: Chat_Custom_Keyboard_Height)
        }
    }
    
    func didChangeTVHeight(_ height: CGFloat)
    {
        customKeyboardView?.frame = CGRect(x: 0, y: (customKeyboardView?.frame.origin.y)! - height, width: screenW(), height: (customKeyboardView?.frame.size.height)! + height)
    }
}
