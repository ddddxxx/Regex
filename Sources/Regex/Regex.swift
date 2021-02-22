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
    
    #if swift(>=5.1)
    @_disfavoredOverload
    public init(_ pattern: String, options: Options = []) throws {
        self.init(try NSRegularExpression(pattern: pattern, options: options))
    }
    #else
    public init(_ pattern: String, options: Options = []) throws {
        self.init(try NSRegularExpression(pattern: pattern, options: options))
    }
    #endif
    
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
            regularExpression.enumerateMatches(in: string, options: options, range: range ?? string.fullNSRange) { result, flags, stop in
                let r = result.map { Match(result: $0, in: string) }
                var s = false
                block(r, flags, &s)
                stop.pointee = ObjCBool(s)
            }
        }
    }
    
    public func matches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> [Match] {
        return regularExpression.matches(in: string, options: options, range: range ?? string.fullNSRange).map {
            Match(result: $0, in: string)
        }
    }
    
    public func numberOfMatches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Int {
        return regularExpression.numberOfMatches(in: string, options: options, range: range ?? string.fullNSRange)
    }
    
    public func firstMatch(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Match? {
        return regularExpression.firstMatch(in: string, options: options, range: range ?? string.fullNSRange).map {
            Match(result: $0, in: string)
        }
    }
    
    public func isMatch(_ string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Bool {
        return regularExpression.firstMatch(in: string, options: options, range: range ?? string.fullNSRange) != nil
    }
    
    public static func ~= (pattern: Regex, value: String) -> Bool {
        return pattern.isMatch(value)
    }
}
