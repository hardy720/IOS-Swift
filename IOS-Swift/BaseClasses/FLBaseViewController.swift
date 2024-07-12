//
//  FLBaseViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/7.
//

import UIKit

protocol FLBaseViewControllerDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

class FLBaseViewController: UIViewController {

    static let BaseViewControllerCellIdentifier_Plain = "BaseViewControllerCellIdentifier_Plain"
    static let BaseViewControllerCellIdentifier_Group = "BaseViewControllerCellIdentifier_Group"
    weak var delegate: FLBaseViewControllerDelegate?
    
    var dataArray = [Any]()
    var headDataArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initData()
        self.initUI()
    }
    
    // MARK: initData
    private func initData()
    {
        headDataArray = []
        dataArray = []
    }
    
    // MARK: initUI
    private func initUI()
    {
        self.view.backgroundColor = .white
    }
    
    // MARK: Lazy
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame:CGRect(x:0, y: 0, width: screenW, height: screenH), style: .init(rawValue: (headDataArray.count == 0) ? 0 : 1)!)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        if (headDataArray.count != 0){
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 0.0001))
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 20))
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.register(BaseGroupTableViewCell.self, forCellReuseIdentifier:FLBaseViewController.BaseViewControllerCellIdentifier_Group)
        }else{
            tableView.register(BasePlainTableViewCell.self, forCellReuseIdentifier:FLBaseViewController.BaseViewControllerCellIdentifier_Plain)
        }
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
}

// MARK: TableviewDelegate,TableviewDatasource
extension FLBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headDataArray.count == 0 ? 1 : headDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let singleDataArray = (headDataArray.count != 0) ? (dataArray[section] as! [String]) : dataArray
        return singleDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if headDataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FLBaseViewController.BaseViewControllerCellIdentifier_Plain, for: indexPath) as! BasePlainTableViewCell
            cell.contentLabel.text = "\(indexPath.row + 1)：\(dataArray[indexPath.row] as? String ?? "")"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FLBaseViewController.BaseViewControllerCellIdentifier_Group, for: indexPath) as! BaseGroupTableViewCell
            let singleDataArray = (headDataArray.count != 0) ? (dataArray[indexPath.section] as! [String]) : dataArray
            cell.contentLabel.text = "\(indexPath.row + 1)：\(singleDataArray[indexPath.row] as! String)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headDataArray.count == 0 {
            let sectionFootView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 0.0001))
            return sectionFootView
        }else{
            let str = headDataArray[section] as! String
            let size = str.fl.rectSize(font: UIFont.systemFont(ofSize: 18), size: CGSize(width: screenW - 20, height: CGFloat(MAXFLOAT)))
            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height:size.height + 20))
            sectionView.backgroundColor = .FLGlobalColor()
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: screenW - 20, height: size.height))
            label.text = str
            label.font = UIFont.systemFont(ofSize: 18)
            label.textAlignment = .left
            label.numberOfLines = 0
            sectionView.addSubview(label)
            return sectionView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if headDataArray.count != 0 {
            let str = headDataArray[section] as! String
            let size = str.fl.rectSize(font: UIFont.systemFont(ofSize: 18), size: CGSize(width: screenW - 20, height: CGFloat(MAXFLOAT)))
            return size.height + 20
        }else{
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFootView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 0.0001))
        sectionFootView.backgroundColor = .orange
        return sectionFootView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat 
    {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if headDataArray.count == 0 {
            FLPrint("Cell at \(indexPath.row) selected")
            delegate?.didSelectCell(at: indexPath)
        }else{
            let rowString = "\(indexPath.row + 1)".fl.prefixAddZero(2)
            let selectorName = "test\(indexPath.section + 1)\(rowString)"
            let selector = Selector("\(selectorName)")
            guard self.responds(to: selector) else {
                FLPrint("没有该方法：\(selector)")
                return
            }
            perform(selector)
        }
    }
    
    // 设置cell的显示 3D缩放动画
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) 
    {
        // 设置cell的显示动画为3D缩放
        // xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        // 设置动画时间为0.25秒，xy方向缩放的最终值为1
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
}


