//
//  TypedRegex.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

import Foundation

public protocol TypedRegex {
    
    associatedtype Result: MatchResultType
    
    static var regex: Regex { get }
}

private extension TypedRegex {
    
    private static func validate() {
        precondition(Result.numberOfCaptureGroups <= regex.numberOfCaptureGroups,
                     "Trying to create typed match result with more captures than regex itself.")
    }
}

public extension TypedRegex where Result: MatchResultType {
    
    static func matches(in string: String, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> [Regex.TypedMatch<Result>] {
        validate()
        // TODO: extra array allocation
        return regex.matches(in: string, options: options, range: range).map(Regex.TypedMatch.init)
    }
    
    static func numberOfMatches(in string: String, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> Int {
        return regex.numberOfMatches(in: string, options: options, range: range)
    }
    
    static func firstMatch(in string: String, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> Regex.TypedMatch<Result>? {
        validate()
        return regex.firstMatch(in: string, options: options, range: range).map(Regex.TypedMatch.init)
    }
    
    static func isMatch(_ string: String, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> Bool {
        return regex.isMatch(string, options: options, range: range)
    }
}
