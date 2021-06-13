//
//  MatchResultType.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2021  Xander Deng. Licensed under the MIT License.
//

public protocol MatchResultType {
    associatedtype MatchResult: ExpressibleByMatchedString
    var match: MatchResult { get }
}

public extension MatchResultType where MatchResult == String {
    var match: String { fatalError() }
}

public protocol MatchResultType1: MatchResultType {
    associatedtype CaptureResult1: ExpressibleByMatchedString
    var capture1: CaptureResult1 { get }
}

public protocol MatchResultType2: MatchResultType1 {
    associatedtype CaptureResult2: ExpressibleByMatchedString
    var capture2: CaptureResult2 { get }
}

public protocol MatchResultType3: MatchResultType2 {
    associatedtype CaptureResult3: ExpressibleByMatchedString
    var capture3: CaptureResult3 { get }
}

public protocol MatchResultType4: MatchResultType3 {
    associatedtype CaptureResult4: ExpressibleByMatchedString
    var capture4: CaptureResult4 { get }
}

public protocol MatchResultType5: MatchResultType4 {
    associatedtype CaptureResult5: ExpressibleByMatchedString
    var capture5: CaptureResult5 { get }
}

// MARK: NumberOfCaptureGroups

private protocol True {}
private enum NumberOfCaptureGroups {
    struct _1<R> {}
    struct _2<R> {}
    struct _3<R> {}
    struct _4<R> {}
    struct _5<R> {}
}

extension NumberOfCaptureGroups._1: True where R: MatchResultType1 {}
extension NumberOfCaptureGroups._2: True where R: MatchResultType2 {}
extension NumberOfCaptureGroups._3: True where R: MatchResultType3 {}
extension NumberOfCaptureGroups._4: True where R: MatchResultType4 {}
extension NumberOfCaptureGroups._5: True where R: MatchResultType5 {}

extension MatchResultType {
    public static var numberOfCaptureGroups: Int {
        if NumberOfCaptureGroups._5<Self>() is True { return 5 }
        if NumberOfCaptureGroups._4<Self>() is True { return 4 }
        if NumberOfCaptureGroups._3<Self>() is True { return 3 }
        if NumberOfCaptureGroups._2<Self>() is True { return 2 }
        if NumberOfCaptureGroups._1<Self>() is True { return 1 }
        return 0
    }
}
