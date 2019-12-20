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
    
    public func enumerateMatches(in string: String, options: MatchingOptions = [], range: NSRange? = nil, using block: (_ result: MatchResult?, _ flags: MatchingFlags, _ stop: inout Bool) -> Void) {
        _regex.enumerateMatches(in: string, options: options, range: range ?? string.fullRange) { result, flags, stop in
            let r = result.map { MatchResult(result: $0, in: string) }
            var s = false
            block(r, flags, &s)
            stop.pointee = ObjCBool(s)
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
}

public func ~= (pattern: Regex, value: String) -> Bool {
    return pattern.isMatch(value)
}

extension Regex: ReferenceConvertible {
    
    public typealias ReferenceType = NSRegularExpression
    
    public func _bridgeToObjectiveC() -> NSRegularExpression {
        return _regex
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: NSRegularExpression, result: inout Regex?) {
        result = Regex(source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: NSRegularExpression, result: inout Regex?) -> Bool {
        result = Regex(source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSRegularExpression?) -> Regex {
        return Regex(source!)
    }
    
    public var description: String {
        return _regex.description
    }
    
    public var debugDescription: String {
        return _regex.debugDescription
    }
}

// MARK: -

extension String {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
    
    subscript(nsRange: NSRange) -> Substring? {
        guard let range = Range(nsRange, in: self) else {
            return nil
        }
        return self[range]
    }
}
