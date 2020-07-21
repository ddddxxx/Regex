//
//  Regex.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

public struct Regex: Equatable, Hashable {
    
    public typealias Options = NSRegularExpression.Options
    public typealias MatchingOptions = NSRegularExpression.MatchingOptions
    public typealias MatchingFlags = NSRegularExpression.MatchingFlags
    
    let _regex: NSRegularExpression
    
    init(_ regex: NSRegularExpression) {
        _regex = regex
    }
    
    public init(_ pattern: String, options: Options = []) throws {
        _regex = try NSRegularExpression(pattern: pattern, options: options)
    }
    
    public init(_ staticPattern: StaticString, options: Options = []) {
        do {
            try self.init(staticPattern.description, options: options)
        } catch {
            preconditionFailure("failed to create regex: \(error)")
        }
    }
}

extension Regex {
    
    public var pattern: String {
        return _regex.pattern
    }
    
    public var options: Options {
        return _regex.options
    }
    
    public var numberOfCaptureGroups: Int {
        return _regex.numberOfCaptureGroups
    }
    
    public static func escapedPattern(for string: String) -> String {
        return NSRegularExpression.escapedPattern(for: string)
    }
}

extension Regex {
    
    public func enumerateMatches(
        in string: String,
        options: MatchingOptions = [],
        range: NSRange? = nil,
        using block: (_ result: MatchResult?, _ flags: MatchingFlags, _ stop: inout Bool) -> Void
    ) {
        // `enumerateMatches` requires escaping closure in non-darwin platforms
        withoutActuallyEscaping(block) { block in
            _regex.enumerateMatches(in: string, options: options, range: range ?? string.fullRange) { result, flags, stop in
                let r = result.map { MatchResult(result: $0, in: string) }
                var s = false
                block(r, flags, &s)
                stop.pointee = ObjCBool(s)
            }
        }
    }
    
    public func matches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> [MatchResult] {
        return _regex.matches(in: string, options: options, range: range ?? string.fullRange).map {
            MatchResult(result: $0, in: string)
        }
    }
    
    public func numberOfMatches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Int {
        return _regex.numberOfMatches(in: string, options: options, range: range ?? string.fullRange)
    }
    
    public func firstMatch(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> MatchResult? {
        return _regex.firstMatch(in: string, options: options, range: range ?? string.fullRange).map {
            MatchResult(result: $0, in: string)
        }
    }
    
    public func isMatch(_ string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Bool {
        return _regex.firstMatch(in: string, options: options, range: range ?? string.fullRange) != nil
    }
    
    public static func ~= (pattern: Regex, value: String) -> Bool {
        return pattern.isMatch(value)
    }
}
