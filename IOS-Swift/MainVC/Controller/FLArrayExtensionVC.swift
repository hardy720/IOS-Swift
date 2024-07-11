//
//  FLArrayExtensionVC.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/10.
//

import UIKit

class FLArrayExtensionVC: FLBaseViewController,FLBaseViewControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
        self.initUI()
    }
    
    func initUI() 
    {
        self.title = "Array+Extension"
        view.addSubview(tableView)
    }
    
    func setData()
    {
        delegate = self
        headDataArray = ["一、数组 的基本扩展", "二、数组 有关索引 的扩展方法", "三、遵守 Equatable 协议的数组 (增删改查) 扩展", "四、遵守 NSObjectProtocol 协议对应数组的扩展方法", "五、针对数组元素是 String 的扩展"]
        dataArray = [["安全的取某个索引的值", "数组添加数组", "数组 -> JSON字符串", "分隔数组", "随机取出数组"], ["获取数组中的指定元素的索引值", "获取元素首次出现的位置", "获取元素最后出现的位置", "获取两个数组的相同元素"], ["删除数组的中的元素(可删除第一个出现的或者删除全部出现的)", "从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素"], ["删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素", "删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除"], ["数组转字符转（数组的元素是 字符串），如：[1, 2, 3] 连接器为 - ，那么转化后为 1-2-3"]]
    }
    
    func didSelectCell(at indexPath: IndexPath)
    {

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

// MARK: - 一、数组 的基本扩
extension FLArrayExtensionVC 
{
    // MARK: 1.01、安全的取某个索引的值
    @objc func test101() {
        let testArray = ["1", "2", "3", "2"]
        let index = 12
        guard let value = testArray.indexValue(safe: index) else {
            FLPrint("取数组 \(testArray) 索引为 \(index) 是没有值的")
            return
        }
        FLPrint("安全的取某个索引的值", "在数组 \(testArray) 中获取索引 \(index) 的值是 \(value)")
    }
    
    // MARK: 1.02、数组添加数组
    @objc func test102() {
        var testArray = ["1", "2", "3"]
        let addArray = ["4", "5", "6"]
        let oldArray = testArray
        testArray.appends(addArray)
        FLPrint("数组新增元素(可转入一个数组)", "原数组是： \(oldArray) 添加 \(addArray) 后为 \(testArray)")
    }
    
    // MARK: 1.03、数组 -> JSON字符串
    @objc func test103() {
        let array = [["a": "1"], "2"] as [Any]
        FLPrint("数组 -> JSON字符串", "数组：\(array) 转为JSON字符串为：\(array.toJSON() ?? "数组 ❌ JSON字符串")")
    }
    
    // MARK: 1.04、分隔数组
    @objc func test104() {
        let array = ["A", "A", "c", "c", "w", "H", "H"]
        let parts = array.split { $0 != $1 }
        FLPrint("分隔数组", "原数组：\(array) 分隔后为：\(parts)")
    }
    
    // MARK: 1.05、随机取出数组
    @objc func test105() {
        /*
        // 十进制 48 - 57 代表 0-9；65-90代表 A-Z； 97-122代表 a-z
        let digits = Array(48...57) + Array(65...90) + Array(97...122)
        // 转字16进制字符串数组
        let stringArray = digits.compactMap { "\($0)".jk.decimalToHexadecimal() }
        // 16进制字符串转UInt16
        let hexStringArray = stringArray.compactMap({ UInt16($0, radix: 16) })
        // UInt16转Unicode字符串
        let resultArray = hexStringArray.compactMap { element in
            let array = [element]
            return String(utf16CodeUnits: array, count: array.count)
        }
        let pick3digits = resultArray[randomPick: 3]  // [8, 9, 0]
        JKPrint("原数组：\(resultArray)", "随机随机取出3个为：\(pick3digits)")
        
        // 十进制 48 - 57 代表 0-9；65-90代表 A-Z； 97-122代表 a-z
        let digits = Array(48...57) + Array(65...90) + Array(97...122)
        // 转字16进制字符串数组
        let resultArray = digits.compactMap {
            // 转字16进制字符串数组
            let hexString = "\($0)".jk.decimalToHexadecimal()
            // 16进制字符串转UInt16
            let hexadecimal = UInt16(hexString, radix: 16) ?? 0
            // UInt16转Unicode字符串
            let array = [hexadecimal]
            return String(utf16CodeUnits: array, count: array.count)
        }
         */
        let resultArray = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let pick3digits = resultArray[randomPick: 3]
        FLPrint("原数组：\(resultArray)", "随机随机取出3个为：\(pick3digits)")
    }
}

// MARK: - 二、数组 有关索引 的扩展方法
extension FLArrayExtensionVC
{
    // MARK: 2.01、获取数组中的指定元素的索引值
    @objc func test201() {
        let testArray = ["1", "2", "3", "2"]
        let element = "2"
        FLPrint("获取数组中的指定元素的索引值", "查找 \(testArray) 中的 \(element) 的索引为：\(testArray.indexes(element))")
    }
    
    // MARK: 2.02、获取元素首次出现的位置
    @objc func test202() {
        let testArray = ["1", "2", "3", "2"]
        let element = "2"
        FLPrint("获取元素首次出现的位置", "\(element) 在数组：\(testArray) 首次出现的索引是：\(testArray.firstIndex(element) ?? 0)")
    }
    
    // MARK: 2.03、获取元素最后出现的位置
    @objc func test203() {
       let testArray = ["1", "2", "3", "2"]
       let element = "2"
       FLPrint("获取元素最后出现的位置", "\(element) 在数组：\(testArray) 最后出现的索引是：\(testArray.lastIndex(element) ?? 0)")
        // testArray.lastIndex(of: element) ?? 0
    }
    
    //MARK: 2.04、获取两个数组的相同元素
    @objc func test204() {
        let array1 = [1, 2, 3, 2]
        let array2 = [0, 2, 4, 9]
        let sameElements = array1.sameElement(array: array2)
        FLPrint("获取\(array1)与\(array2) 两个数组的相同元素是：\(sameElements)")
    }
}

// MARK: - 三、遵守 Equatable 协议的数组 (增删改查) 扩展
extension FLArrayExtensionVC
{
    // MARK: 3.01、删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    @objc func test301() 
    {
        var testArray = ["1", "2", "3", "2"]
        let oldArray = testArray
        let element = "2"
        let newArray = testArray.remove(element, isRepeat: false)
        FLPrint("删除数组的中的元素(可删除第一个出现的或者删除全部出现的)", "原数组为：\(oldArray) 删除其中的值：\(element) 后数组为：\(newArray)")
    }
    
    // MARK: 3.02、从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
    @objc func test302() {
        var testArray = ["1", "2", "3", "2"]
        let removeArray = ["2", "3"]
        let oldArray = testArray
        let newArray = testArray.removeArray(removeArray, isRepeat: false)
        FLPrint("从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素", "原数组为：\(oldArray) 删除的数组是：\(removeArray) 后数组为：\(newArray)")
    }
}

// MARK: - 四、遵守 NSObjectProtocol 协议对应数组的扩展方法
extension FLArrayExtensionVC
{
    // MARK: 4.01、删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素
    @objc func test401() {
        var testArray = ["1".fl.toNSString, "2".fl.toNSString, "3".fl.toNSString, "2".fl.toNSString]
        let oldArray = testArray
        let element = "2".fl.toNSString
        let newArray = testArray.remove(object: element, isRepeat: false)
        FLPrint("删除数组中遵守NSObjectProtocol协议的元素，是否删除重复的元素)", "原数组为：\(oldArray) 删除其中的值：\(element) 后数组为：\(newArray)")
    }
    
    // MARK: 4.02、删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除
    @objc func test402() {
        var testArray = ["1".fl.toNSString, "2".fl.toNSString, "3".fl.toNSString, "2".fl.toNSString]
        let removeArray = ["2".fl.toNSString, "3".fl.toNSString]
        let oldArray = testArray
        let newArray = testArray.removeArray(objects: removeArray, isRepeat: true)
        FLPrint("删除一个遵守NSObjectProtocol的数组中的元素，支持重复删除", "原数组为：\(oldArray) 删除的数组是：\(removeArray) 后数组为：\(newArray)")
    }
}

// MARK: - 五、针对数组元素是 String 的扩展
extension FLArrayExtensionVC
{
    
    // MARK: 5.01、 数组转字符转（数组的元素是 字符串），如：["1", "2", "3"] 连接器为 - ，那么转化后为 "1-2-3"
    @objc func test501() {
        let testArray = ["1", "2", "3", "4", "5", "6"]
        let testString = testArray.toStrinig(separator: "-")
        FLPrint("数组转字符转（数组的元素是 字符串）", "数组：\(testArray) 转为字符串为：\(testString)")
    }
}
