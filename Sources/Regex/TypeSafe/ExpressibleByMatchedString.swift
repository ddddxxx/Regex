//
//  ExpressibleByMatchedString.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

public protocol ExpressibleByMatchedString {
    init?(matchedString: String)
}

extension ExpressibleByMatchedString where Self: LosslessStringConvertible {
    
    public init?(matchedString: String) {
        self.init(matchedString)
    }
}

extension Optional: ExpressibleByMatchedString where Wrapped: ExpressibleByMatchedString {
    
    public init(matchedString: String) {
        self = Wrapped(matchedString: matchedString)
    }
}

extension Int: ExpressibleByMatchedString {}
extension Int8: ExpressibleByMatchedString {}
extension Int16: ExpressibleByMatchedString {}
extension Int32: ExpressibleByMatchedString {}
extension Int64: ExpressibleByMatchedString {}
extension UInt: ExpressibleByMatchedString {}
extension UInt8: ExpressibleByMatchedString {}
extension UInt16: ExpressibleByMatchedString {}
extension UInt32: ExpressibleByMatchedString {}
extension UInt64: ExpressibleByMatchedString {}
extension Float32: ExpressibleByMatchedString {}
extension Float64: ExpressibleByMatchedString {}
extension String: ExpressibleByMatchedString {}
