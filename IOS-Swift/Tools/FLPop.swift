//
//  FLPop.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/10.
//

import UIKit
import Foundation

public struct FLPop<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol FLPOPCompatible {}

public extension FLPOPCompatible {
    
    static var fl: FLPop<Self>.Type {
        get{ FLPop<Self>.self }
        set {}
    }
    
    var fl: FLPop<Self> {
        get { FLPop(self) }
        set {}
    }
}

/// Define Property protocol
internal protocol FLSwiftPropertyCompatible {
    /// Extended type
    associatedtype T
    ///Alias for callback function
    typealias SwiftCallBack = ((T?) -> ())
    ///Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack?  { get set }
}


