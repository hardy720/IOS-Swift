//
//  FLUserModel.swift
//  IOS-Swift
//
//  Created by hardy on 2024/10/19.
//

import Foundation
import HandyJSON


class FLUserModel : HandyJSON
{
    var id : String = ""
    var userName : String = ""
    var passWord : String = ""
    var avatar : String = ""
    required init() {
        
    }
}


