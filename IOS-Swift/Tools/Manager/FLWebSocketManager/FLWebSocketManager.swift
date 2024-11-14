//
//  FLWebSocketManager.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/30.
//

import Foundation
import Starscream
  
class FLWebSocketManager: NSObject, WebSocketDelegate
{
    // 标记单例
    static let shared = FLWebSocketManager()
      
    // WebSocket 属性
    private var socket: WebSocket!
    private var heartBeatTimer: Timer?
    private var isConnected = false
    
    // WebSocket URL
    private let urlString = "ws://localhost:8181/api/websocket/"
    
    // 私有初始化方法，防止外部创建实例
    private override init() 
    {
        super.init()
        setupWebSocket()
    }
    
    // 设置 WebSocket 连接
    private func setupWebSocket() 
    {
        let userModel = FLUserInfoManager.shared.getUserInfo()
        let urlStr = urlString + userModel.id
        guard let url = URL(string: urlStr) else {
            fatalError("Invalid URL string: \(urlString)")
        }
        
        let request = URLRequest(url: url)
        // 你可以在这里配置 request 的其他属性，比如 HTTP 方法、头部信息等（如果需要的话）
        // request.httpMethod = "GET" // 默认情况下，WebSocket 使用的是类似 "GET" 的升级请求，但通常不需要显式设置
        // request.addValue("some-value", forHTTPHeaderField: "Some-Header") // 如果需要添加自定义头部信息
        socket = WebSocket(request: request)
        socket.delegate = self
    }
      
    // 连接到 WebSocket 服务器
    func connect()
    {
        // 尝试连接，Starscream 会处理连接逻辑并调用相应的委托方法
        socket.connect()
        FLPrint("Attempting to connect to WebSocket server...")
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient)
    {
        switch event {
        case .connected(let headers):
            FLPrint("websocket is connected: \(headers)")
            isConnected = true
            startHeartBeat()
        case .disconnected(let reason, let code):
            FLPrint("websocket is disconnected: \(reason) with code: \(code)")
            isConnected = false
            stopHeartBeat()
        case .text(let string):
            if let encryptedText = decrypt(base64String: string) {
                FLPrint("Received text: \(encryptedText)")
                NotificationCenter.default.post(name: Notification.Name(WebSocket_Recived_Message_Noti), object: nil, userInfo: ["message": encryptedText])
            }
        case .binary(let data):
            FLPrint("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
            break
        case .error(let error):
            FLPrint(error!)
            isConnected = false
            break
        case .peerClosed:
            break
        }
    }
    
    func isWebSocketConnected() -> Bool 
    {
        return isConnected
    }
    
    // 发送消息到 WebSocket 服务器
    func sendMessage(_ message: String)
    {
        // 直接发送消息，不检查 readyState，因为 Starscream 会处理发送逻辑
        socket.write(string: message)
        FLPrint("Attempting to send message: \(message)")
        // 注意：这里的打印信息可能会在实际消息发送之前显示，因为 Starscream 是异步工作的
        // 如果需要确认消息是否成功发送，你应该依赖 WebSocketDelegate 的回调方法
    }
    
    // 发送data到 WebSocket 服务器
    func sendDataMessage(_ data: NSData)
    {
        // 直接发送消息，不检查 readyState，因为 Starscream 会处理发送逻辑
        socket.write(data: data as Data)
        // 注意：这里的打印信息可能会在实际消息发送之前显示，因为 Starscream 是异步工作的
        // 如果需要确认消息是否成功发送，你应该依赖 WebSocketDelegate 的回调方法
    }
      
    // 断开与 WebSocket 服务器的连接
    func disconnect() 
    {
        socket.disconnect()
        socket = nil
        stopHeartBeat()
        FLPrint("Disconnected from WebSocket server.")
    }
    
    deinit {
        disconnect()
    }
      
    // 心跳方法
    private func startHeartBeat()
    {
        heartBeatTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Web_Socket_Heart_Count), repeats: true) { [weak self] _ in
            self?.sendHeartBeat()
        }
    }
      
    private func stopHeartBeat() 
    {
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }
      
    private func sendHeartBeat() 
    {
        if isConnected {
            let userModel = FLUserInfoManager.shared.getUserInfo()
            var msg = FLWebSocketMessage.init()
            msg.data = "ping"
            msg.chart_Type = .HeartBeat
            msg.msg_From = userModel.id
            msg.msg_To = userModel.id
            sentData(msg: msg)
        }
    }
    
    func sentData(msg : FLWebSocketMessage)
    {
        let dict = WebSocketMessageToDictionary(message: msg)
        if dict != nil {
            let string = dictionaryToJson(dict!)!
            if let encryptedText = encrypt(string: string) {
                print("Encrypted: \(encryptedText)")
                sendMessage(encryptedText)
            } else {
                print("Encryption failed")
            }
        }
    }
    
    
    func stringToData(_ base64String: String) -> Data? 
    {
        return Data(base64Encoded: base64String)
    }
    
    // 将 FLWebSocketMessage 转换为字典
    func WebSocketMessageToDictionary(message: FLWebSocketMessage) -> [String: Any]?
    {
        do {
            // 编码结构体为 JSON 数据
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(message)
            
            // 将 JSON 数据解码为字典
            let dict = try Dictionary(fromJSONData: jsonData)
            return dict
        } catch {
            FLPrint("Error converting FLWebSocketMessage to dictionary: \(error)")
            return nil
        }
    }
   
    func dictionaryToJson(_ dictionary: [String: Any]) -> String? 
    {
        do {
            // 将字典转换为Data对象
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            // 将Data对象转换为字符串
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                FLPrint("Failed to convert Data to String")
                return nil
            }
        } catch {
            FLPrint("Error converting dictionary to JSON: \(error)")
            return nil
        }
    }
}


// 扩展 Dictionary，方便将 JSON 数据转换为字典
extension Dictionary where Key == String, Value == Any 
{
    init(fromJSONData data: Data) throws {
        self = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
}
