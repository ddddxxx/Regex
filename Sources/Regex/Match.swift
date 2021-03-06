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
        
        // Use both String and NSString to avoid bridging overhead.
        //
        // This causes about 5% performance loss for valid slice (why), and 30%
        // performance gain for invalid slice.
        //
        // See RegexTests.testCaptureBackingStorage
        init(string: String, result: NSTextCheckingResult) {
            precondition(result.range.location != NSNotFound)
            captures = (0..<result.numberOfRanges).map { index in
                let nsRange = result.range(at: index)
                guard nsRange.location != NSNotFound else { return nil }
                return Capture(string: string, range: nsRange)
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
        public var content: Substring {
            return captures[0].unsafelyUnwrapped.content
        }
        
        public subscript(_ captureGroupIndex: Int) -> Capture? {
            return captures[captureGroupIndex]
        }
    }
}
