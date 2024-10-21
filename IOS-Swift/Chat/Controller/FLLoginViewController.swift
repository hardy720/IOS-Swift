//
//  FLLoginViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/17.
//

import UIKit

class FLLoginViewController: UIViewController
{

    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) 
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
        self.initNoti()
    }
    
    func initUI()
    {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .gray
        
        view.addSubview(bview)
        bview.addSubview(line1)
        bview.addSubview(nameTF)
        bview.addSubview(passWordTF)
        bview.addSubview(line2)
        bview.addSubview(commitBtn)
        
        commitBtn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)

        self.initLayout()
    }
    
    func initLayout()
    {
        bview.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(300)
            make.width.equalTo(400)
        }
        line1.snp.makeConstraints { make in
            make.centerY.equalTo(bview).offset(-20)
            make.width.equalTo(bview)
            make.height.equalTo(0.5)
        }
        
        nameTF.snp.makeConstraints { make in
            make.bottom.equalTo(line1).offset(-10)
            make.left.equalTo(bview).offset(20)
            make.right.equalTo(bview).offset(-20)
        }
        
        passWordTF.snp.makeConstraints { make in
            make.top.equalTo(line1.snp_bottomMargin).offset(20)
            make.left.equalTo(bview).offset(20)
            make.right.equalTo(bview).offset(-20)
        }
        
        line2.snp.makeConstraints { make in
            make.top.equalTo(passWordTF.snp_bottomMargin).offset(20)
            make.width.equalTo(bview)
            make.height.equalTo(0.5)
        }
        
        commitBtn.snp.makeConstraints { make in
            make.left.right.equalTo(bview)
            make.height.equalTo(45)
            make.bottom.equalTo(bview).offset(-25)
        }
    }
    
    var nameTF: UITextField =
    {
        let TF = UITextField.init()
        TF.placeholder = "输入用户名"
        TF.text = "hardy"
        return TF
    }()
    
    var passWordTF: UITextField =
    {
        let TF = UITextField.init()
        TF.text = "123456"
        TF.isSecureTextEntry = true
        TF.placeholder = "输入密码"
        return TF
    }()
    
    var line1: UILabel =
    {
        let line1 = UILabel.init()
        line1.backgroundColor = Text_Light_Gray
        return line1
    }()
    
    var bview: UIView =
    {
        let view = UIView.init()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    var line2: UILabel =
    {
        let label = UILabel.init()
        label.backgroundColor = Text_Light_Gray
        return label
    }()
    
    var commitBtn : UIButton =
    {
        let button = UIButton.init(type: .custom)
        button.setTitle("登录", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    @objc func commitBtnClick()
    {
        let paramDict = ["userName":nameTF.text!,"passWord":passWordTF.text!]
        FLNetworkManager.shared.requestLoginDatas(.get, URLString: "\(BASE_URL)user/login", paramaters: paramDict) { response in
            let json = JSON(response)
            let alertMessage = json["msg"].stringValue;
            if json["code"].intValue == 200 {
                let dic_info = json["data"].dictionaryObject
                let userM = UserInfoModel.deserialize(from: dic_info)
                let token = json["token"].stringValue
                let userInfoM = UserInfoManager.shareInstance
                userInfoM.saveUserInfo(userM: userM!)
                userInfoM.saveToken(token: token)

                self.perform(#selector(delayExecution), with: nil, afterDelay: TimeInterval(TOASTSHOWTIME))
            }else{
                
            }
            FLToast.showToastAction(message: alertMessage as NSString)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FLLoginViewController
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
        UIView.animate(withDuration: 1.5) {
            self.bview.snp.updateConstraints { make in
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view).offset(-100)
                make.height.equalTo(300)
                make.width.equalTo(400)
            }
        }
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification)
    {
        UIView.animate(withDuration: 1.5) {
            self.bview.snp.updateConstraints { make in
                make.center.equalTo(self.view)
                make.height.equalTo(300)
                make.width.equalTo(400)
            }
        }
    }
}
