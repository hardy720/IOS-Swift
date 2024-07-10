//
//  FLArrayExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/10.
//

import UIKit

class FLArrayExtensionVC: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
    }
    
    func setData()
    {
        self.title = "Array+Extension"
        delegate = self

        headDataArray = ["一、数组 的基本扩展", "二、数组 有关索引 的扩展方法", "三、遵守 Equatable 协议的数组 (增删改查) 扩展", "四、遵守 NSObjectProtocol 协议对应数组的扩展方法", "五、针对数组元素是 String 的扩展"]
        dataArray = [["安全的取某个索引的值", "数组添加数组", "数组 -> JSON字符串", "分隔数组", "随机取出数组"], ["获取数组中的指定元素的索引值", "获取元素首次出现的位置", "获取元素最后出现的位置", "获取两个数组的相同元素"], ["删除数组的中的元素(可删除第一个出现的或者删除全部出现的)", "从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素"], ["删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素", "删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除"], ["数组转字符转（数组的元素是 字符串），如：[1, 2, 3] 连接器为 - ，那么转化后为 1-2-3"]]
    }
    
    func didSelectCell(at indexPath: IndexPath) {

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
