//
//  Utilities.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension NSString {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}

extension String {
    
    // isCocoaOrContiguousASCII
    private var isCocoa: Bool {
        if !isContiguousUTF8 {
            // Opaque string. Currently, the only case is non-contiguous-ASCII
            // lazily-bridged NSString. But it can change in the future.
            return true
        }
        if let stringClass = NSClassFromString("__NSCFString") {
            return (self as NSString).isKind(of: stringClass)
        }
        return false
    }
    
    func makeCocoa() -> NSString {
        if isCocoa {
            return self as NSString
        } else {
            return NSString(string: self)
        }
    }
    
    func makeNative() -> String {
        var str = self
        str.makeContiguousUTF8()
        return str
    }
}
