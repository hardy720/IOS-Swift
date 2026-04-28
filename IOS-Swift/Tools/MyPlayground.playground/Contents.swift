import UIKit
import PlaygroundSupport

// 1. 创建一个用于温度转换的视图控制器
class TemperatureViewController: UIViewController {

    // 定义UI组件
    let celsiusTextField = UITextField()
    let fahrenheitLabel = UILabel()
    let convertButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 配置摄氏温度输入框
        celsiusTextField.borderStyle = .roundedRect
        celsiusTextField.placeholder = "输入摄氏度 (C)"
        celsiusTextField.keyboardType = .numberPad
        celsiusTextField.textAlignment = .center
        
        // 配置华氏温度标签
        fahrenheitLabel.text = "华氏温度: ??? °F"
        fahrenheitLabel.textAlignment = .center
        fahrenheitLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        // 配置转换按钮
        convertButton.setTitle("转换", for: .normal)
        convertButton.addTarget(self, action: #selector(convertTemperature), for: .touchUpInside)
        
        // 将组件添加到视图
        view.addSubview(celsiusTextField)
        view.addSubview(fahrenheitLabel)
        view.addSubview(convertButton)
        
        // 进行自动布局 (使用简单的frame，你也可以尝试NSLayoutConstraint)
        let width: CGFloat = 200
        let height: CGFloat = 40
        let centerX = (view.bounds.width / 2) - (width / 2)
        
        celsiusTextField.frame = CGRect(x: centerX, y: 100, width: width, height: height)
        convertButton.frame = CGRect(x: centerX, y: 160, width: width, height: height)
        fahrenheitLabel.frame = CGRect(x: centerX, y: 220, width: width, height: height)
    }
    
    // 转换逻辑
    @objc func convertTemperature() {
        // 获取输入的文本
        guard let text = celsiusTextField.text, let celsius = Double(text) else {
            fahrenheitLabel.text = "无效输入，请输入数字"
            return
        }
        
        // 转换公式: °F = °C × 9/5 + 32
        let fahrenheit = (celsius * 9 / 5) + 32
        fahrenheitLabel.text = "华氏温度: \(fahrenheit) °F"
        
        // 收起键盘
        view.endEditing(true)
    }
}

// 2. 创建ViewController实例并显示
let controller = TemperatureViewController()
PlaygroundPage.current.liveView = controller
