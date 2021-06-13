//
//  TypedRegexTests.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import XCTest
import Foundation
import Regex

class TypedRegexTests: XCTestCase {
    
    @available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
    func testNamedGroup() {
        enum NumberRegex: TypedRegex {
            struct Result: MatchResultType {
                let number: Int
            }
            static let regex = Regex(#"(?<number>\d+)"#)
        }
        XCTAssertEqual(NumberRegex.firstMatch(in: "123")?.number, 123)
    }
}
