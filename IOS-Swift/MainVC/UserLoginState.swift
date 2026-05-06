//
//  UserLoginState.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

class UserLoginState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userName = ""
}

