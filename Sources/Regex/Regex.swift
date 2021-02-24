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
    
    let regularExpression: NSRegularExpression
    
    init(_ regex: NSRegularExpression) {
        regularExpression = regex
    }
    
    @_disfavoredOverload
    public init(_ pattern: String, options: Options = []) throws {
        self.init(try NSRegularExpression(pattern: pattern, options: options))
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
        return regularExpression.pattern
    }
    
    public var options: Options {
        return regularExpression.options
    }
    
    public var numberOfCaptureGroups: Int {
        return regularExpression.numberOfCaptureGroups
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
        using block: (_ result: Match?, _ flags: MatchingFlags, _ stop: inout Bool) -> Void
    ) {
        // `enumerateMatches` requires escaping closure in non-darwin platforms
        withoutActuallyEscaping(block) { block in
            let nsstring = string as NSString
            regularExpression.enumerateMatches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange) { result, flags, stop in
                let r = result.map { Match(string: string, nsstring: nsstring, result: $0) }
                var s = false
                block(r, flags, &s)
                stop.pointee = ObjCBool(s)
            }
        }
    }
    
    public func matches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> [Match] {
        let nsstring = string as NSString
        return regularExpression.matches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange).map {
            Match(string: string, nsstring: nsstring, result: $0)
        }
    }
    
    public func numberOfMatches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Int {
        let nsstring = string as NSString
        return regularExpression.numberOfMatches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange)
    }
    
    public func firstMatch(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Match? {
        let nsstring = string as NSString
        return regularExpression.firstMatch(in: nsstring as String, options: options, range: range ?? nsstring.fullRange).map {
            Match(string: string, nsstring: nsstring, result: $0)
        }
    }
    
    public func isMatch(_ string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Bool {
        let nsstring = string as NSString
        return regularExpression.firstMatch(in: nsstring as String, options: options, range: range ?? nsstring.fullRange) != nil
    }
    
    public static func ~= (pattern: Regex, value: String) -> Bool {
        return pattern.isMatch(value)
    }
}
