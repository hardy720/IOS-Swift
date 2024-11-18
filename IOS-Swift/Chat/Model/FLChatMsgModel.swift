//
//  FLChatMsgModel.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/12.
//

import Foundation

enum FLMessageType : Int,Codable
{
    case msg_unknown = -1
    case msg_text = 0
    case msg_audio = 1
    case msg_image = 2
    case msg_video = 3
}

class FLChatMsgModel
{
    var id : Int = 0
    var friendId: Int = -1
    var avatar : String = ""
    var nickName : String = ""
    var contentStr : String = ""
    var lastContent : String = ""
    var msgType : FLMessageType = .msg_unknown
    var isMe : Bool = false
    var mediaTime : String = ""
    var imgWidth : CGFloat = 0
    var imgHeight : CGFloat = 0
}

enum FLSocketMessageType: Int, Codable
{
    case Unknown = -1
    case HeartBeat = 0
    case P2P_Chat_Private = 1
}

struct FLWebSocketMessage: Codable
{
    var chart_Type: FLSocketMessageType = .Unknown
    var msg_From : String = ""
    var msg_To : String = ""
    var data: String = ""
    var msg_Type : FLMessageType = .msg_unknown
    var user_Name : String = ""
    var chart_Avatar : String = ""
    var msg_img_height : CGFloat = 0
    var msg_img_weight : CGFloat = 0
}
