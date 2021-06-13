//
//  Regex.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

/// A simple wrapper around `NSRegularExpression`.
public struct Regex: Equatable, Hashable {
    
    /// These constants define the regular expression options.
    public typealias Options = NSRegularExpression.Options
    
    /// The matching options constants specify the reporting, completion and
    /// matching rules to the expression matching methods. These constants are
    /// used by all methods that search for, or replace values, using a regular
    /// expression.
    public typealias MatchingOptions = NSRegularExpression.MatchingOptions
    
    /// Set by the Block as the matching progresses, completes, or fails. Used
    /// by the method `enumerateMatches(in:options:range:using:)`.
    public typealias MatchingFlags = NSRegularExpression.MatchingFlags
    
    let regularExpression: NSRegularExpression
    
    init(_ regex: NSRegularExpression) {
        regularExpression = regex
    }
    
    /// Create a regular expression with the specified pattern and options.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern to compile.
    ///   - options: The regular expression options that are applied to the
    ///   expression during matching.
    /// - Throws: Throws an NSError object if the regular expression pattern is
    /// invalid
    @_disfavoredOverload
    public init(_ pattern: String, options: Options = []) throws {
        self.init(try NSRegularExpression(pattern: pattern, options: options))
    }
    
    /// Create a regular expression with the static pattern and options.
    ///
    /// This method doesn't throw since you use a string literal as the input.
    /// An invalid regular expression pattern is considered to be an program
    /// error and result in a crash.
    public init(_ staticPattern: StaticString, options: Options = []) {
        do {
            try self.init(staticPattern.description, options: options)
        } catch {
            preconditionFailure("failed to create regex: \(error)")
        }
    }
    
    /// The regular expression pattern.
    public var pattern: String {
        return regularExpression.pattern
    }
    
    /// The options used when the regular expression option was created.
    ///
    /// The options property specifies aspects of the regular expression
    /// matching that are always used when matching the regular expression. For
    /// example, if the expression is case sensitive, allows comments, ignores
    /// metacharacters, etc.
    public var options: Options {
        return regularExpression.options
    }
    
    /// The number of capture groups in the regular expression.
    ///
    /// A capture group consists of each possible match within a regular
    /// expression. Each capture group can then be used in a replacement
    /// template to insert that value into a replacement string.
    ///
    /// This value puts a limit on the values of n for `$n` in templates, and it
    /// determines the number of captures in the returned `Match` instances
    /// returned in the `match...` methods.
    public var numberOfCaptureGroups: Int {
        return regularExpression.numberOfCaptureGroups
    }
    
    /// Returns a string by adding backslash escapes as necessary to protect any
    /// characters that would match as pattern metacharacters.
    ///
    /// Returns a string by adding backslash escapes as necessary to the given
    /// string, to escape any characters that would otherwise be treated as
    /// pattern metacharacters. You typically use this method to match on a
    /// particular string within a larger pattern.
    ///
    /// For example, the string `"(N/A)"` contains the pattern metacharacters
    /// `(`, `/`, and `)`. The result of adding backslash escapes to this string
    /// is `#"\(N\/A\)"#`.
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
            let nsstring = string.makeCocoa()
            regularExpression.enumerateMatches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange) { result, flags, stop in
                let r = result.map { Match(originalString: nsstring as String, checkingResult: $0) }
                var s = false
                block(r, flags, &s)
                stop.pointee = ObjCBool(s)
            }
        }
    }
    
    public func matches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> [Match] {
        let nsstring = string.makeCocoa()
        return regularExpression.matches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange).map {
            Match(originalString: nsstring as String, checkingResult: $0)
        }
    }
    
    public func numberOfMatches(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Int {
        let nsstring = string.makeCocoa()
        return regularExpression.numberOfMatches(in: nsstring as String, options: options, range: range ?? nsstring.fullRange)
    }
    
    public func firstMatch(in string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Match? {
        let nsstring = string.makeCocoa()
        return regularExpression.firstMatch(in: nsstring as String, options: options, range: range ?? nsstring.fullRange).map {
            Match(originalString: nsstring as String, checkingResult: $0)
        }
    }
    
    public func isMatch(_ string: String, options: MatchingOptions = [], range: NSRange? = nil) -> Bool {
        let nsstring = string.makeCocoa()
        return regularExpression.firstMatch(in: nsstring as String, options: options, range: range ?? nsstring.fullRange) != nil
    }
    
    public static func ~= (pattern: Regex, value: String) -> Bool {
        return pattern.isMatch(value)
    }
}
