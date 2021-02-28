//
//  RegexTests.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import XCTest
import Foundation
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
            XCTAssert(original === str)
        }
    }
    
    func testPatternMatch() {
        let regex = Regex("(foo|bar)")
        
        XCTAssert(regex ~= "foo")
        
        switch "bar" {
        case regex:
            break
        default:
            XCTFail()
        }
        
        switch "baz" {
        case regex:
            XCTFail()
        default:
            break
        }
    }
    
    func testAsciiNativeStringPerformance() {
        let string = TestResources.dullBoy().makeNative()
        let pattern = Regex(#"[A-Z][a-z]+"#)
        measure {
            let matchs = pattern.matches(in: string)
            XCTAssertEqual(matchs.count, 2000)
            for match in matchs {
                _ = match.string
            }
        }
    }
    
    func testAsciiCocoaStringPerformance() {
        let string = TestResources.dullBoy().makeCocoa()
        let pattern = Regex(#"[A-Z][a-z]+"#)
        measure {
            let matchs = pattern.matches(in: string)
            XCTAssertEqual(matchs.count, 2000)
            for match in matchs {
                _ = match.string
            }
        }
    }
    
    func testNonAsciiNativeStringPerformance() {
        let string = TestResources.shijing().makeNative()
        let pattern = Regex(#"(?<=[，。])(.+)？"#)
        measure {
            let matchs = pattern.matches(in: string)
            for match in matchs {
                _ = match.string
            }
        }
    }
    
    func testNonAsciiCocoaStringPerformance() {
        let string = TestResources.shijing().makeCocoa()
        let pattern = Regex(#"(?<=[，。])(.+)？"#)
        measure {
            let matchs = pattern.matches(in: string)
            for match in matchs {
                _ = match.string
            }
        }
    }
}

enum TestResources {
    
    static func shijing() -> String {
        let resources = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Resources")
        let url = resources.appendingPathComponent("shijing").appendingPathExtension("txt")
        return try! String(contentsOf: url)
    }
    
    static func dullBoy() -> String {
        return String(repeating: "All work and no play makes Jack a dull boy\n", count: 1000)
    }
}

extension String {
    
    func makeNative() -> String {
        return String(Array(self))
    }
    
    func makeCocoa() -> String {
        return NSString(string: self) as String
    }
}
