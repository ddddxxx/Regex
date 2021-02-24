//
//  Capture.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension Regex.Match {
    
    /// A captured string for a single match.
    public struct Capture: Equatable, Hashable {
        
        private enum Slice: Equatable, Hashable {
            
            /// Valid captured substring.
            case valid(substring: Substring)
            
            /// Captured string breaks extended grapheme cluster thus the
            /// substring cannot be formed.
            ///
            /// The original string is stored for later slicing.
            case invalid(original: NSString)
        }
        
        /// Captured content.
        private let slice: Slice
        
        /// The matching range.
        public let range: NSRange
        
        init(string: String, nsstring: NSString, range: NSRange) {
            self.range = range
            if let r = Range(range, in: string) {
                self.slice = .valid(substring: string[r])
            } else {
                self.slice = .invalid(original: nsstring)
            }
        }
        
        /// The matched string.
        public var string: String {
            switch slice {
            case let .valid(substring):
                return String(substring)
            case let .invalid(original):
                return original.substring(with: range)
            }
        }
        
        /// The matched substring.
        ///
        /// Returns `nil` if captured string breaks extended grapheme cluster
        /// thus the substring cannot be formed.
        /* public */ var content: Substring? {
            switch slice {
            case let .valid(substring):
                return substring
            default:
                return nil
            }
        }
    }
}

// for test only
extension Regex.Match.Capture {
    
    var originalString: NSString? {
        switch slice {
        case .valid:
            return nil
        case let .invalid(original: str):
            return str
        }
    }
}
