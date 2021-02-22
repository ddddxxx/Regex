//
//  Utilities.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension StringProtocol {
    
    var fullNSRange: NSRange {
        return NSRange(startIndex..<endIndex, in: self)
    }
}
