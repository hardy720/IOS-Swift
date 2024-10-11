//
//  FLPopMenu.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/5.
//

/**
 * 功能：
 * 只需要传入菜单箭头点位置、菜单宽度、数据源即可。

 * 1、支持任意点弹出（点是基于整个屏幕位置）
 * 2、会根据点位置自动计算菜单位置
 * 3、背景色、文字等支持自定义设置
 * 4、菜单最大宽度=屏幕-边距    最大高度=屏幕高度一半
 */

import UIKit

protocol FLPopMenuDelegate :NSObjectProtocol
{
    func popMenuDidSelectIndex(index:Int)
}

public enum FLPopMenuConfigure 
{
    case PopMenuTextFont(UIFont)          //菜单文字字体
    case PopMenuTextColor(UIColor)        //菜单文字颜色
    case PopMenuBackgroudColor(UIColor)   //菜单背景色
    case popMenuCornorRadius(CGFloat)     //菜单圆角
    case popMenuItemHeight(CGFloat)       //菜单行高度
    case popMenuSplitLineColor(UIColor)   //菜单分割线颜色
    case popMenuIconLeftMargin(CGFloat)   //icon左间距
    case popMenuMargin(CGFloat)           //菜单与屏幕边距
    case popMenuAlpha(CGFloat)            //菜单背景透明度
}

public class FLPopMenu: UIView 
{
    //delegate
    weak var delegate : FLPopMenuDelegate?
    //block
    public var didSelectMenuBlock:((_ index:Int)->Void)?

    //／*  -----------------------  外部参数 通过configure设置 ---------------------------- *／
    //区域外背景透明度
    private var popMenuOutAlpha:CGFloat = 0.3
    //背景色
    private var popMenuBgColor:UIColor = UIColor.white
    //圆角弧度
    private var popMenuCornorRadius:CGFloat = 6
    //文字颜色
    private var popMenuTextColor:UIColor = UIColor.gray
    //字体大小等
    private var popMenuTextFont:UIFont = UIFont.systemFont(ofSize: 17)
    //菜单高度
    private var popMenuItemHeight:CGFloat = 44.0
    //菜单分割线颜色
    private var popMenuSplitLineColor:UIColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
    //icon左间距
    private var popMenuIconLeftMargin:CGFloat = 15
    //菜单与屏幕边距
    private var popMenuMargin:CGFloat = 10
    
    //／*  -----------------------  外部参数 over------------------------------------------ *／
    private var arrowPoint : CGPoint = CGPoint.zero         //小箭头位置
    private var arrowViewWidth : CGFloat = 15               //三角箭头宽
    private var arrowViewHeight : CGFloat = 10               //三角箭头高
    private var popData:[(icon:String,title:String)]!       //数据源
    
    static let cellID:String = "FLPopMenuCellID"
    private var myFrame:CGRect!
    private var arrowView : UIView! = nil
    
    var tableView:UITableView! = nil

    
 ///   初始化菜单
 ///
 /// - Parameters:
 ///   - menuWidth: 菜单宽度
 ///   - arrow: 箭头位置是popmenu相对整个屏幕的位置
 ///   - datas: 数据源，icon允许传空，数据源没数据，不会显示菜单
 ///   - configure: 配置信息，可不传
    init(menuWidth:CGFloat,arrow:CGPoint,datas:[(icon:String,title:String)],configures:[FLPopMenuConfigure] = []) {
        super.init(frame: UIScreen.main.bounds)
        self.frame = UIScreen.main.bounds
        //读取配置
        configures.forEach { (config) in
            switch (config){
                case let .PopMenuTextFont(value):
                    popMenuTextFont = value
                case let .PopMenuTextColor(value):
                    popMenuTextColor = value
                case let .PopMenuBackgroudColor(value):
                    popMenuBgColor = value
                case let .popMenuCornorRadius(value):
                    popMenuCornorRadius = value
                case let .popMenuItemHeight(value):
                    popMenuItemHeight = value
                case let .popMenuSplitLineColor(value):
                    popMenuSplitLineColor = value
                case let .popMenuIconLeftMargin(value):
                    popMenuIconLeftMargin = value
                case let .popMenuMargin(value):
                    popMenuMargin = value
                case let .popMenuAlpha(value):
                    popMenuOutAlpha = value
            }
        }
        
        popData = datas
        //设置myFrame size  ,original会在后面计算
        myFrame = CGRect(x: 0, y: 0, width: menuWidth, height: popMenuItemHeight*CGFloat(popData.count))
        myFrame.size.height = min(screenH()/2, myFrame.height)
        myFrame.size.width = min(screenW() - popMenuMargin*2, myFrame.width)
        
        //设置肩头，与屏幕间隔10
        arrowPoint = arrow
        arrowPoint.x = max(popMenuMargin, min(arrowPoint.x, screenW()-popMenuMargin))
    }
    
    required public init?(coder aDecoder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() 
    {
        self.backgroundColor = UIColor.black.withAlphaComponent(popMenuOutAlpha)
        let arrowPs = getArrowPoints()
        myFrame.origin = arrowPs.3
        let isarrowUP = arrowPs.4
        FLPrint(arrowPs)
        //箭头
        arrowView = UIView(frame: CGRect(x: myFrame.origin.x, y: isarrowUP ? myFrame.origin.y - arrowViewHeight : myFrame.origin.y + myFrame.height, width: myFrame.width, height: arrowViewHeight))
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: arrowPs.0)
        path.addLine(to: arrowPs.1)
        path.addLine(to: arrowPs.2)
        layer.path=path.cgPath
        layer.fillColor = popMenuBgColor.cgColor
        arrowView.layer.addSublayer(layer)
        self.addSubview(arrowView)
        
        tableView = UITableView(frame: CGRect(x: myFrame.origin.x,y: myFrame.origin.y,width: myFrame.width,height: myFrame.height), style: .plain)
        tableView.register(FLPopMenuCell.classForCoder(), forCellReuseIdentifier: FLPopMenu.cellID)
        tableView.backgroundColor = popMenuBgColor
        tableView.layer.cornerRadius = popMenuCornorRadius
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        UIView.animate(withDuration: 0.3) {
            self.addSubview(self.tableView)
        }
    }
   
    
    /// 计算箭头位置
    /// - Returns: (三角箭头顶，三角箭头左，三角箭头右，tableview 原点，是否箭头朝上)
    func getArrowPoints() -> (CGPoint,CGPoint,CGPoint,CGPoint,Bool) 
    {
        if arrowPoint.x <= popMenuMargin {
            arrowPoint.x = popMenuMargin
        }
        if arrowPoint.x >= screenW() - popMenuMargin{
            arrowPoint.x = screenW() - popMenuMargin
        }
        var originalPoint = CGPoint.zero
        
        //箭头中间距离左边距离
        var arrowMargin:CGFloat = popMenuMargin
        if arrowPoint.x < screenW() / 2 {
            if (arrowPoint.x > myFrame.width/2) {
                arrowMargin = myFrame.width/2
                originalPoint = CGPoint(x: arrowPoint.x - myFrame.width/2, y: arrowPoint.y+arrowViewHeight)
            } else {
                arrowMargin = arrowPoint.x-popMenuMargin
                originalPoint = CGPoint(x: popMenuMargin, y: arrowPoint.y+arrowViewHeight)
            }
        } else {
            if (screenW() - arrowPoint.x) < myFrame.width/2{
                arrowMargin = (myFrame.width - screenW() + arrowPoint.x )
                originalPoint = CGPoint(x: screenW() - popMenuMargin-myFrame.width, y: arrowPoint.y + arrowViewHeight)
            }else{
                arrowMargin = myFrame.width/2
                originalPoint = CGPoint(x: arrowPoint.x-myFrame.width/2, y: arrowPoint.y+arrowViewHeight)
            }
        }
        
        //箭头朝上
        if (screenH() - arrowPoint.y) > myFrame.height
        {
            return (CGPoint(x: arrowMargin, y: 0),CGPoint(x: arrowMargin-arrowViewWidth/2, y: arrowViewHeight),CGPoint(x: arrowMargin+arrowViewWidth/2, y: arrowViewHeight),originalPoint,true)
        } else {
            originalPoint.y = arrowPoint.y-myFrame.height-arrowViewHeight
            return (CGPoint(x: arrowMargin, y: arrowViewHeight),CGPoint(x: arrowMargin-arrowViewWidth/2, y: 0),CGPoint(x: arrowMargin+arrowViewWidth/2, y: 0),originalPoint,false)
        }
    }
}

// MARK: - 页面显示、隐藏
extension FLPopMenu
{
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) 
    {
        if touches.first?.view != tableView{
            dismiss()
        }
    }
    
    public func show() 
    {
        if popData.isEmpty{
            return
        }
        initViews()
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = CFTimeInterval(0.01)
        var values = [AnyHashable]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        self.layer.add(animation, forKey: nil)
        getKeyWindow().addSubview(self)
    }
    
    public func dismiss()
    {
        self.removeFromSuperview()
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension FLPopMenu : UITableViewDataSource,UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return popData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        if popData.count > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: FLPopMenu.cellID) as! FLPopMenuCell
            
            let model = popData[indexPath.row]
            cell.setConfig(_txtColor: popMenuTextColor, _lineColor: popMenuSplitLineColor, _txtFont: popMenuTextFont, _iconLeft: popMenuIconLeftMargin)
            if indexPath.row == popData.count - 1 {
                cell.fill(iconName: model.icon, title: model.title, islast: true)
            }else{
                 cell.fill(iconName: model.icon, title: model.title)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat 
    {
        return popMenuItemHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat 
    {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.delegate != nil{
            self.delegate?.popMenuDidSelectIndex(index: indexPath.row)
        }
        if didSelectMenuBlock != nil {
            didSelectMenuBlock!(indexPath.row)
        }
        dismiss()
    }
}



/// UITableViewCell
class FLPopMenuCell: UITableViewCell 
{
    var iconImage : UIImageView!
    var lblTitle : UILabel!
    var line : UIView!
    
    //自定义属性
    var lineColor : UIColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
    var txtColor : UIColor = UIColor.black
    var txtFont : UIFont = UIFont.systemFont(ofSize: 17)
    var iconLeft : CGFloat = 15
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) 
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        iconImage = UIImageView()
        self.contentView.addSubview(iconImage)
        self.selectionStyle = .none
        
        lblTitle = UILabel()
        self.contentView.addSubview(lblTitle)
        
        line = UIView()
        self.contentView.addSubview(line)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fill(iconName:String,title:String,islast:Bool = false) 
    {
        iconImage.image = UIImage(named: iconName)
        lblTitle.text = title
        line.isHidden = islast
    }
    
    func setConfig(_txtColor:UIColor,_lineColor:UIColor,_txtFont:UIFont,_iconLeft:CGFloat) 
    {
        txtColor = _txtColor
        txtFont = _txtFont
        lineColor = _lineColor
        iconLeft = _iconLeft
        
        line.backgroundColor = lineColor
        lblTitle.textColor = txtColor
        lblTitle.font = txtFont
    }
    
    override func layoutSubviews() 
    {
        super.layoutSubviews()
        self.iconImage.frame = CGRect(x: iconLeft, y: (self.bounds.size.height - 20)/2, width: 20, height: 20)
        self.lblTitle.frame = CGRect(x: 20+iconLeft*2, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height)
        self.line.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
    }
}
