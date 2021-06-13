//
//  TypedMatch.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

extension Regex {

    @dynamicMemberLookup
    public struct TypedMatch<Result: MatchResultType> {
        let match: Regex.Match
    }
}

private func convertToResult<T: ExpressibleByMatchedString>(_ matchedString: String) -> T {
    guard let result = T(matchedString: matchedString) else {
        preconditionFailure("Failed to create typed match result from string. Use Optional for match result type that may produce nil.")
    }
    return result
}

private func resultFromNil<T>(type: T.Type = T.self) -> T {
    guard let type = T.self as? ExpressibleByNilLiteral.Type else {
        preconditionFailure("Trying to create typed match result from a capture group that didn't participate in the match. Use Optional type for optional capture.")
    }
    return (type.init(nilLiteral: ()) as! T)
}

// MARK: - Named Group

public extension Regex.TypedMatch {
    
    @available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    subscript<T: ExpressibleByMatchedString>(dynamicMember keyPath: KeyPath<Result, T>) -> T {
        guard let name = keyPath.fieldName else {
            preconditionFailure("Failed to get field name from key path \(keyPath). Use key path of stored property instead.")
        }
        return (match.group(named: name)?.string).map(convertToResult) ?? resultFromNil()
    }
}

// MARK: Indexed Group

public extension Regex.TypedMatch where Result: MatchResultType0 {
    var match: Result.MatchResult {
        convertToResult(match.string)
    }
}

public extension Regex.TypedMatch where Result: MatchResultType1 {
    var capture1: Result.CaptureResult1 {
        (match[1]?.string).map(convertToResult) ?? resultFromNil()
    }
}

public extension Regex.TypedMatch where Result: MatchResultType2 {
    var capture2: Result.CaptureResult2 {
        (match[2]?.string).map(convertToResult) ?? resultFromNil()
    }
}

public extension Regex.TypedMatch where Result: MatchResultType3 {
    var capture3: Result.CaptureResult1 {
        (match[3]?.string).map(convertToResult) ?? resultFromNil()
    }
}

public extension Regex.TypedMatch where Result: MatchResultType4 {
    var capture4: Result.CaptureResult4 {
        (match[4]?.string).map(convertToResult) ?? resultFromNil()
    }
}

public extension Regex.TypedMatch where Result: MatchResultType5 {
    var capture5: Result.CaptureResult5 {
        (match[5]?.string).map(convertToResult) ?? resultFromNil()
    }
}
