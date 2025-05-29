//
//  FlTestViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/14.
//

import UIKit

class FlTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        // 假设这是我们的父视图
        let parentView = UIView(frame: self.view.bounds)
        parentView.backgroundColor = .gray
        self.view.addSubview(parentView)
                  
        // 红色视图的宽高
        let viewSize: CGFloat = 30.0
        // 视图之间的边距
        let margin: CGFloat = 10.0
                  
                // 计算每个红色视图的位置
        let horizontalSpacing = margin + viewSize
        let verticalSpacing = margin + viewSize
        let columns = 3.0
        let rows = 3.0
                  
        // 计算父视图内部可用区域的大小
        let usableWidth = parentView.bounds.width - CGFloat((columns - 1)) * margin
        let usableHeight = parentView.bounds.height - CGFloat((rows - 1)) * margin
                  
        // 计算每个红色视图在父视图中的 x 和 y 坐标
        let columnWidth = usableWidth/columns
        let rowHeight = usableHeight/rows
          
        for column in 0..<3 {
            for row in 0..<3 {
                let x = margin + CGFloat(column) * (columnWidth + margin) - margin
                let y = margin + CGFloat(row) * (rowHeight + margin) - margin
                  
                let redView = UIView(frame: CGRect(x: x, y: y, width: viewSize, height: viewSize))
                redView.backgroundColor = .red
                parentView.addSubview(redView)
            }
        }
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
