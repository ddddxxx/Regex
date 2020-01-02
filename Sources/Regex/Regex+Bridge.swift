//
//  Regex+Bridge.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension Regex: ReferenceConvertible {
    
    public typealias ReferenceType = NSRegularExpression
    
    public func _bridgeToObjectiveC() -> NSRegularExpression {
        return _regex
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: NSRegularExpression, result: inout Regex?) {
        result = Regex(source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: NSRegularExpression, result: inout Regex?) -> Bool {
        result = Regex(source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSRegularExpression?) -> Regex {
        return Regex(source!)
    }
    
    public var description: String {
        return _regex.description
    }
    
    public var debugDescription: String {
        return _regex.debugDescription
    }
}
