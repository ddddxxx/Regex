//
//  Match.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension Regex {

    /// A single match of a regex. It also behave as A group of captured strings.
    public struct Match: Equatable, Hashable, RandomAccessCollection {
        
        /// A captured string for a single match.
        public struct Capture: Equatable, Hashable {
            
            /// The matched string.
            public let string: String
            
            /// The matching range.
            public let range: NSRange
        }
        
        let originalString: String
        let checkingResult: NSTextCheckingResult
        
        /// The range of the entire match.
        public var range: NSRange {
            return self[0].unsafelyUnwrapped.range
        }
        
        /// The entire matched string.
        public var string: String {
            return self[0].unsafelyUnwrapped.string
        }
        
        /// The position of the first capture group, which always corresponds to
        /// the entire match.
        public var startIndex: Int { 0 }
        
        public var endIndex: Int { checkingResult.numberOfRanges }
        
        /// The captured string at the specified position.
        ///
        /// The 0th capture always corresponds to the entire match. A capture
        /// group might be `nil` if it didn't participate in the match.
        public subscript(captureGroupIndex: Int) -> Capture? {
            let range = checkingResult.range(at: captureGroupIndex)
            guard range.location != NSNotFound else { return nil }
            let string = (originalString as NSString).substring(with: range)
            return Capture(string: string, range: range)
        }
        
        /// The captured string with specified name.
        ///
        /// A capture group might be `nil` if it didn't participate in the match.
        @available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
        public subscript(captureGroupName: String) -> Capture? {
            let range = checkingResult.range(withName: captureGroupName)
            guard range.location != NSNotFound else { return nil }
            let string = (originalString as NSString).substring(with: range)
            return Capture(string: string, range: range)
        }
    }
}
