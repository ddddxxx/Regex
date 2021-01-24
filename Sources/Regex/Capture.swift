//
//  Match.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension Regex.Match {
    
    /// A captured string for a single match.
    public struct Capture: Equatable, Hashable {
        
        private enum Content: Equatable, Hashable {
            
            /// Valid captured substring.
            case valid(substring: Substring)
            
            /// Captured string breaks extended grapheme cluster thus the substring cannot be formed.
            ///
            /// The original string is stored for later slicing.
            case invalid(original: NSString)
            
            static func validate(string: String, range: NSRange) -> Content {
                if let r = Range(range, in: string) {
                    return .valid(substring: string[r])
                } else {
                    return .invalid(original: string as NSString)
                }
            }
        }
        
        /// Captured content.
        private let _content: Content
        
        /// The matching range.
        public let range: NSRange
        
        init(string: String, range: NSRange) {
            self._content = .validate(string: string, range: range)
            self.range = range
        }
        
        /// The matched string.
        public var string: String {
            switch _content {
            case let .valid(substring):
                return String(substring)
            case let .invalid(original):
                return original.substring(with: range)
            }
        }
        
        /* public */ var content: Substring? {
            switch _content {
            case let .valid(substring):
                return substring
            default:
                return nil
            }
        }
    }
}
