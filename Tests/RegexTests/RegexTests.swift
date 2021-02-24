//
//  RegexTests.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import XCTest
@testable import Regex

class RegexTests: XCTestCase {
    
    func testInit() {
        let pattern = "(foo|bar)"
        XCTAssertNoThrow(try Regex(pattern))
        let badPattern = "("
        XCTAssertThrowsError(try Regex(badPattern))
    }
    
    func testMatches() {
        let source = "foo"
        let regex = Regex("f.o")
        
        XCTAssertTrue(regex.isMatch(source))
        XCTAssertTrue(regex ~= source)
        
        switch source {
        case regex: break
        default: XCTFail()
        }
    }
    
    func testReplace() {
        let source = "123 foo fo0 bar"
        let regex = Regex("(foo|bar)")
        let result = source.replacingMatches(of: regex, with: "$1baz")
        XCTAssertEqual(result, "123 foobaz fo0 barbaz")
    }
    
    func testCaptureGroup() {
        let source = "123 foo bar baz"
        let regex = Regex(#"(\d+)(boo)? (foo) bar"#)
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
        let regex = Regex("caf.")
        let match = regex.firstMatch(in: source)!
        XCTAssertNil(match.content)
        XCTAssertEqual(match.string, "cafe")
    }
    
    func testCaptureBackingStorage() throws {
        let source = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}\u{200D}\u{1F467}"
        let regex = Regex(#"[\x{1F467}-\x{1F469}]"#)
        
        let matchs = regex.matches(in: source)
        XCTAssertEqual(matchs.count, 4)
        let originalStrings = matchs.compactMap { $0[0]?.originalString }
        XCTAssertEqual(originalStrings.count, 4)
        
        let original = originalStrings[0]
        for str in originalStrings {
            // FIXME: bridge
            XCTAssert(original === str)
        }
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testMatches", testMatches),
        ("testReplace", testReplace),
        ("testCaptureGroup", testCaptureGroup),
        ("testExtendedGraphemeClusters", testExtendedGraphemeClusters),
        ("testCaptureBackingStorage", testCaptureBackingStorage),
    ]
}
