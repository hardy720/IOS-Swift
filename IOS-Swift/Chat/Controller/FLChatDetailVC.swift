//
//  ChatDetailVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/10.
//

import UIKit
import SwiftyJSON

class FLChatDetailVC: UIViewController
{
    var chatModel : FLChatListModel? = nil
    private var dataArr: [FLChatMsgModel] = []
    private static let cellID_type_text : String = "Chat_Detail_CellID_Text"
    private static let cellID_type_audio : String = "Chat_Detail_CellID_Audio"
    private static let cellID_type_img : String = "Chat_Detail_CellID_Img"

    private var customKeyboardView : FLCustomKeyboardView? = nil
    private var isShowKeyboard : Bool = false
    private var isShowAddView : Bool = false

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
        dataArr = FLChatDetailDao.init().fetchChatDetailTable(userID: "\(chatModel!.id)")!
        FLPrint(dataArr)
        
        if UserDefaults.standard.bool(forKey: Test_Test_IsOpen) {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction1), userInfo: nil, repeats: true)

        }
        cellScrollToBottom()
    }
    
    
    
    func initUI()
    {
        view.backgroundColor = .white
        self.title = chatModel?.friendName
        view.addSubview(tableView!)
        customKeyboardView = FLCustomKeyboardView.init(frame: CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom, width: screenW(), height: Chat_Custom_Keyboard_Height))
        customKeyboardView?.delegate = self
        customKeyboardView?.userId = "\(chatModel?.id)"
        view.addSubview(customKeyboardView!)
    }
    
    lazy var tableView: UITableView? =
    {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW(), height: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatTextMessageCell.classForCoder(), forCellReuseIdentifier: FLChatDetailVC.cellID_type_text)
        tableView.register(ChatAudioMessageCell.classForCoder(), forCellReuseIdentifier: FLChatDetailVC.cellID_type_audio)
        tableView.register(ChatImgMessageCell.classForCoder(), forCellReuseIdentifier: FLChatDetailVC.cellID_type_img)
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
        if isShowAddView {
            customKeyboardView?.addView.isHidden = true
            isShowAddView = false
        }
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
extension FLChatDetailVC : UITableViewDataSource,UITableViewDelegate,FLCustomKeyboardViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
            
        case .msg_audio:
            let cell = tableView.dequeueReusableCell(withIdentifier: FLChatDetailVC.cellID_type_audio, for: indexPath) as! ChatAudioMessageCell
            cell.setModel(with: model)
            return cell
            
        case .msg_image:
            let cell = tableView.dequeueReusableCell(withIdentifier: FLChatDetailVC.cellID_type_img, for: indexPath) as! ChatImgMessageCell
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
            
        case .msg_audio:
            height = 70
            break
        case .msg_image:
            height = model.imgHeight + 20
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
        sendTextMsg(text: text)
    }
    
    func didChangeTVHeight(_ height: CGFloat)
    {
        customKeyboardView?.frame = CGRect(x: 0, y: (customKeyboardView?.frame.origin.y)! - height, width: screenW(), height: (customKeyboardView?.frame.size.height)! + height)
    }
    
    // 开始录音
    func startRecording() 
    {
        
    }
    
    func errorRecordPermission()
    {
        self.view.makeToast(Chat_Keyboart_Record_Check_Permission, duration: 3.0, position: .center)
    }
    
    func FinishRecord()
    {
        self.sendAudioMsg()
    }
    
    func errorShort() 
    {
        self.view.makeToast(Chat_Keyboard_Too_Short_Record_Alert, duration: 2.0, position: .center)
    }
    
    func recordChangeCustomKeyboardViewFrame() 
    {
        if isShowAddView {
            customKeyboardView?.frame = CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom , width: screenW(), height: Chat_Custom_Keyboard_Height)
            isShowAddView = false
            tableView?.frame = CGRectMake(0, 0, screenW(), screenH() - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom)
        }
    }
    
    
    // 增加功能图片，视频。
    func startShowAdd()
    {
        if isShowKeyboard || !isShowAddView {
            view.endEditing(true)
            customKeyboardView?.frame = CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_AddView_Height - Chat_Custom_Keyboard_Height - fWindowSafeAreaInset().bottom, width: screenW(), height: Chat_Custom_Keyboard_Height + Chat_Custom_Keyboard_AddView_Height)
            isShowAddView = true
            customKeyboardView?.addView.isHidden = false
            tableView?.frame = CGRectMake(0, 0, screenW(), screenH() - Chat_Custom_Keyboard_Height - Chat_Custom_Keyboard_AddView_Height - fWindowSafeAreaInset().bottom)
            cellScrollToBottom()
        }else{
            customKeyboardView?.inputTextView.becomeFirstResponder()
            customKeyboardView?.addView.isHidden = true
            isShowAddView = false
        }
    }
    
    // 发送消息更多功能
    func moreAddIndex(index: Int)
    {
        switch index {
        case 0:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
            break
            
        case 1:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
            break

        default:
            self.view.makeToast(App_Toast_Developing, duration: 2.0, position: .center)

            break
        }
    }
    
    // 发送图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {

        if let selectedImage = info[.originalImage] as? UIImage {
            self.sendImageMsg(image: selectedImage)
            FLNetworkManager.shared.uploadPicture(myImg: selectedImage, imageKey: "file", URlName: "\(BASE_URL)/upload/uploadImg") { response in
                let json = JSON(response)
                let message = json["msg"].stringValue;
                if json["code"].intValue == 200 {
                    let imgPath = json["data"].stringValue
                }else{
                    
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Send Message -
extension FLChatDetailVC
{
    // 发送文字消息
    func sendTextMsg(text: String)
    {
        if !text.fl.isStringBlank() {
            let userInfoModel = FLUserInfoManager.shared.getUserInfo()
            let model = FLChatMsgModel.init()
            model.nickName = userInfoModel.userName
            model.avatar = userInfoModel.avatar
            model.contentStr = text
            model.msgType = .msg_text
            model.isMe = true
            let isOk = FLChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
            dataArr.append(model)
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
                self.tableView?.beginUpdates()
                self.tableView?.insertRows(at: [indexPath], with: .bottom)
                self.tableView?.endUpdates()
            }
            cellScrollToBottom()
            customKeyboardView?.frame = CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - keyboardHeight, width: screenW(), height: Chat_Custom_Keyboard_Height)
        }
    }
    
    // 发送录音消息
    func sendAudioMsg()
    {
        let userInfoModel = FLUserInfoManager.shared.getUserInfo()
        let model = FLChatMsgModel.init()
        model.nickName = userInfoModel.userName
        model.avatar = userInfoModel.avatar
        model.contentStr = (FLAudioRecorder.shared.recordFilePath as String)
        model.msgType = .msg_audio
        model.isMe = true
        model.mediaTime = "\(FLAudioRecorder.shared.recordSeconds)"
        let isOk = FLChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        dataArr.append(model)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: [indexPath], with: .bottom)
            self.tableView?.endUpdates()
        }
        cellScrollToBottom()
    }
    
    // 发送图片信息
    func sendImageMsg(image: UIImage)
    {
        let imagePathName = Date.fl.currentDate_SSS_() + ".png"
        let isSave = self.saveImageToDocumentsDirectory(image: image, fileName: getImgPath + "/" + imagePathName)
        let userInfoModel = FLUserInfoManager.shared.getUserInfo()
        let model = FLChatMsgModel.init()
        var width = image.size.width
        var height = image.size.height
        if width > screenW() / 2 {
            width = screenW() / 2
        }
        if height > screenH() / 2 {
            height = screenH() / 2
        }
        model.imgWidth = width
        model.imgHeight = height
        model.nickName = userInfoModel.userName
        model.avatar = userInfoModel.avatar
        model.contentStr = imagePathName
        model.msgType = .msg_image
        model.isMe = true
        let isOk = FLChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        dataArr.append(model)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: [indexPath], with: .bottom)
            self.tableView?.endUpdates()
        }
        cellScrollToBottom()
//            customKeyboardView?.frame = CGRect(x: 0, y: screenH() - Chat_Custom_Keyboard_Height - keyboardHeight, width: screenW(), height: Chat_Custom_Keyboard_Height)
    }
    
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> Bool 
    {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            do {
                try jpegData.write(to: filePath)
                return true
            } catch {
                print("Failed to save image: \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
}

// MARK: - Test -
extension FLChatDetailVC
{
    @objc func timerAction()
    {
//        test1()
    }
    
    @objc func timerAction1()
    {
        test2()
    }

    func test1()
    {
        let model = FLChatMsgModel.init()
        model.contentStr = String.fl.shuffleString()
        model.msgType = .msg_text
        let i = Int.fl.random(within: 0..<10)
        if i > 5 {
            model.isMe = false
            model.avatar = chatModel!.friendAvatar
        }else{
            let userInfoModel = FLUserInfoManager.shared.getUserInfo()
            model.nickName = userInfoModel.userName
            model.avatar = userInfoModel.avatar
        }
        let isOk = FLChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
        dataArr.append(model)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: [indexPath], with: .bottom)
            self.tableView?.endUpdates()
        }
        cellScrollToBottom()
    }
    
    func test2()
    {
        let model = FLChatMsgModel.init()
        model.contentStr = getRandomFilePathInFolder() ?? ""
        model.msgType = .msg_audio
        let i = Int.fl.random(within: 0..<60)
        if i > 30 {
            model.isMe = false
            model.avatar = chatModel!.friendAvatar
        }else{
            model.isMe = true
            let userInfoModel = FLUserInfoManager.shared.getUserInfo()
            model.nickName = userInfoModel.userName
            model.avatar = userInfoModel.avatar
        }
        model.mediaTime = "\(i)"
        let isOk = FLChatDetailDao.init().insertChatListTable(chatID: "\(chatModel!.id)", model: model)
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
