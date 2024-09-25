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
    private var isShowKeyboard : Bool = false
    private var keyboardHeight : CGFloat = 0
    private var isSended: Bool = true
    private var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewIsAppearing(_ animated: Bool) 
    {
        super.viewIsAppearing(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    deinit
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initUI()
        self.initNoti()
    }
    
    func initData()
    {
        dataArr = ChatDetailDao.init().fetchChatDetailTable(userID: "\(chatModel!.id)")!
        print(dataArr)
        
        if UserDefaults.standard.bool(forKey: Test_Test_IsOpen) {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        cellScrollToBottom()
    }
    
    
    
    func initUI()
    {
        view.backgroundColor = .white
        self.title = chatModel?.nickName
        view.addSubview(tableView!)
        customKeyboardView = FLCustomKeyboardView.init(frame: CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom, width: screenW(), height: Chat_Custom_Keyboard_Height))
        customKeyboardView?.delegate = self
        view.addSubview(customKeyboardView!)
        initRecord()
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

// MARK: - 录音 -
extension FLChatDetailVC
{
    func initRecord()
    {
        // 开始录音
        customKeyboardView?.recordButton.recordTouchDownAction = { recordButton in
            print("开始录音")
            if FLAudioRecorder.shared.getAuthorizedStatus() {
                let recordPath = getRecordPath + "/" + "\(self.chatModel!.id)" + "_" + Date.fl.currentDate_SSS() + ".caf"
                FLAudioRecorder.shared.startRecord(recordPath:recordPath as NSString)
            }else{
                self.view.makeToast(Chat_Keyboart_Record_Check_Permission, duration: 3.0, position: .center)
            }
        }
        
        // 完成录音
        customKeyboardView?.recordButton.recordTouchUpInsideAction = { recordButton in
            print("完成录音")
            if FLAudioRecorder.shared.getAuthorizedStatus() {
                FLAudioRecorder.shared.stopSoundRecord();
            }
        }
        
        // 取消录音
        customKeyboardView?.recordButton.recordTouchUpOutsideAction = { recordButton in
            print("取消录音")
        }
        
        // 将取消录音
        customKeyboardView?.recordButton.recordTouchDragExitAction = { recordButton in
            print("将取消录音")
        }
        
        // 继续录音
        customKeyboardView?.recordButton.recordTouchDragInsideAction = { recordButton in
            print("继续录音")
        }
    }
}

// MARK: - 工具
extension FLChatDetailVC
{
    // tableviewCell 滚动到最后
    func cellScrollToBottom()
    {
        if !self.dataArr.isEmpty {
            DispatchQueue.main.async {                
                self.tableView!.scrollToLast(at: .bottom, animated: false)
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
        if !isSended {
            self.view.endEditing(true)
        }
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

// MARK: - Test -
extension FLChatDetailVC
{
    @objc func timerAction()
    {
        test()
    }

    func test()
    {
        let model = FLChatMsgModel.init()
        model.contentStr = String.fl.shuffleString()
        model.msgType = .msg_text
        let i = Int.fl.random(within: 0..<10)
        if i > 5 {
            model.isMe = false
            model.avatar = chatModel!.avatar
            model.nickName = getUserNickName()
        }else{
            model.isMe = true
            model.nickName = getUserNickName()
            model.avatar = getUserAvatar()
        }
        let isOk = ChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        dataArr.append(model)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: [indexPath], with: .bottom)
            self.tableView?.endUpdates()
        }
        cellScrollToBottom()
    }
}
