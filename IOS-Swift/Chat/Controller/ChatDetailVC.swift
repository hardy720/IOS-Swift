//
//  ChatDetailVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/10.
//

import UIKit

class ChatDetailVC: UIViewController 
{
    var userModel : ChatListModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initUI()
    {
        view.backgroundColor = .white
        self.title = userModel?.nickName
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
