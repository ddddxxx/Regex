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
        enum URLRegex: TypedRegex {
            struct Result: MatchResultType {
                enum Proto: String, ExpressibleByMatchedString { case http, https }
                let proto: Proto
                let host: String
                let port: Int?
                let path: String?
                let query: String?
            }
            static let regex = Regex(#"^(?<proto>.+)://(?<host>[^\s:/]+)(?::(?<port>[0-9]+))?(?<path>.+)?(?:\?(?<query>.+))$"#)
        }
        let match = URLRegex.firstMatch(in: "http://www.foo.com:123/bar?baz=1")!
        XCTAssertEqual(match.proto, .http)
        XCTAssertEqual(match.host, "www.foo.com")
        XCTAssertEqual(match.port, 123)
        XCTAssertEqual(match.path, "/bar")
        XCTAssertEqual(match.query, "baz=1")
    }
}
