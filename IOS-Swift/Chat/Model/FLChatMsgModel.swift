//
//  FLChatMsgModel.swift
//  IOS-Swift
//
//  Created by hardy on 2024/9/12.
//

import Foundation

enum FLMessageType : Int
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
    var avatar : String = ""
    var nickName : String = ""
    var contentStr : String = ""
    var lastContent : String = ""
    var msgType : FLMessageType = .msg_unknown
    var isMe : Bool = false
    var mediaTime : String = ""
}
