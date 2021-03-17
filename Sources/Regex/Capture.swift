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
            case substring(Substring)
            
            /// Captured string breaks extended grapheme cluster thus the
            /// substring cannot be formed. Use UTF16View instead
            case utf16(Substring.UTF16View)
            
            var substring: Substring {
                switch self {
                case let .substring(s): return s
                case let .utf16(s):     return Substring(s)
                }
            }
            
            static func == (lhs: Slice, rhs: Slice) -> Bool {
                return lhs.substring == rhs.substring
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(substring)
            }
        }
        
        /// Captured content.
        private let slice: Slice
        
        /// The matching range.
        public let range: NSRange
        
        init(string: String, range: NSRange) {
            self.range = range
            if let r = Range(range, in: string) {
                self.slice = .substring(string[r])
            } else {
//                let lower = String.UTF16View.Index(encodedOffset: range.lowerBound)
//                let upper = String.UTF16View.Index(encodedOffset: range.upperBound)
                let lower = String.UTF16View.Index(utf16Offset: range.location, in: string)
                let upper = string.utf16.index(lower, offsetBy: range.length)
                let utf16 = string.utf16[lower..<upper]
                self.slice = .utf16(utf16)
            }
        }
        
        /// The matched string.
        public var string: String {
            switch slice {
            case let .substring(s): return String(s)
            case let .utf16(s):     return String(s)!
            }
        }
        
        /// The matched substring.
        public var content: Substring {
            return slice.substring
        }
    }
}
