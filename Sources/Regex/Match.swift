//
//  Match.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension Regex {

    /// A single match of a regex.
    public struct Match: Equatable, Hashable {
        
        /// A group of captured strings for a single match.
        ///
        /// The 0th capture always corresponds to the entire match. A capture
        /// group might be `nil` If it didn't participate in the match.
        public let captures: [Capture?]
        
        init(string: String, nsstring: NSString, result: NSTextCheckingResult) {
            precondition(result.range.location != NSNotFound)
            captures = (0..<result.numberOfRanges).map { index in
                let nsRange = result.range(at: index)
                guard nsRange.location != NSNotFound else { return nil }
                return Capture(string: string, nsstring: nsstring, range: nsRange)
            }
        }
        
        /// The range of the entire match.
        public var range: NSRange {
            return captures[0].unsafelyUnwrapped.range
        }
        
        /// The entire matched string.
        public var string: String {
            return captures[0].unsafelyUnwrapped.string
        }
        
        /// The entire matched substring.
        ///
        /// Returns `nil` if matched string breaks extended grapheme cluster
        /// thus the substring cannot be formed.
        /* public */ var content: Substring? {
            return captures[0].unsafelyUnwrapped.content
        }
        
        public subscript(_ captureGroupIndex: Int) -> Capture? {
            return captures[captureGroupIndex]
        }
    }
}
