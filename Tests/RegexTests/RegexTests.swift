//
//  RegexTests.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import XCTest
import Regex

class RegexTests: XCTestCase {
    
    func testMatches() {
        let source = "foo"
        let regex = try! Regex("f.o")
        
        XCTAssertTrue(regex.isMatch(source))
        XCTAssertTrue(regex ~= source)
        
        switch source {
        case regex: break
        default:    XCTFail()
        }
    }
    
    func testReplace() {
        let source = "123 foo fo0 bar"
        let regex = try! Regex("(foo|bar)")
        let result = source.replacingMatches(of: regex, with: "$1baz")
        XCTAssertEqual(result, "123 foobaz fo0 barbaz")
    }
    
    func testCaptureGroup() {
        let source = "123 foo bar baz"
        let regex = try! Regex(#"(\d+)(boo)? (foo) bar"#)
        let match = regex.firstMatch(in: source)!
        XCTAssertEqual(match.string, "123 foo bar")
        XCTAssertEqual(match.captures.count, 4)
        XCTAssertEqual(match[0]?.string, "123 foo bar")
        XCTAssertEqual(match[1]?.string, "123")
        XCTAssertNil(match[2])
        XCTAssertEqual(match[3]?.string, "foo")
    }
    
    func testExtendedGraphemeClusters() {
        let source = "cafe\u{301}" // café
        let regex = try! Regex("caf.")
        let match = regex.firstMatch(in: source)!
        XCTAssertEqual(match.string, "cafe")
        XCTAssertNil(Range(match.range, in: source))
    }
    
    static var allTests = [
        ("testMatches", testMatches),
        ("testReplace", testReplace),
        ("testCaptureGroup", testCaptureGroup),
        ("testExtendedGraphemeClusters", testExtendedGraphemeClusters),
    ]
}
