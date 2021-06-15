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
        XCTAssertEqual(match.count, 4)
        XCTAssertEqual(match[0]?.string, "123 foo bar")
        XCTAssertEqual(match[1]?.string, "123")
        XCTAssertNil(match[2])
        XCTAssertEqual(match[3]?.string, "foo")
    }
    
    func testExtendedGraphemeClusters() {
        let source = "cafe\u{301}" // café
        let cafe = Regex("caf.").firstMatch(in: source)!
        XCTAssertEqual(cafe.string, "cafe")
        let accent = Regex(".$").firstMatch(in: source)!
        XCTAssertEqual(accent.string, "\u{301}")
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
            let matchs = pattern.matches(in: string as String)
            XCTAssertEqual(matchs.count, 2000)
            for match in matchs {
                _ = match.string
            }
        }
    }
    
    func testNonAsciiNativeStringPerformance() {
        let string = TestResources.shijing().makeNative()
        let pattern = Regex(#"(?<=[，。？！\s])([\u4E00-\u9FFF]+?)？"#)
        measure {
            let matchs = pattern.matches(in: string)
            XCTAssertEqual(matchs.count, 330)
            for match in matchs {
                _ = match.string
            }
        }
    }
    
    func testNonAsciiCocoaStringPerformance() {
        let string = TestResources.shijing().makeCocoa()
        let pattern = Regex(#"(?<=[，。？！\s])([\u4E00-\u9FFF]+?)？"#)
        measure {
            let matchs = pattern.matches(in: string as String)
            XCTAssertEqual(matchs.count, 330)
            for match in matchs {
                _ = match.string
            }
        }
    }
}

enum TestResources {
    
    static func shijing() -> String {
        #if compiler(>=5.3)
        let path = #filePath
        #else
        let path = #file
        #endif
        let resources = URL(fileURLWithPath: path).deletingLastPathComponent().appendingPathComponent("Resources")
        let url = resources.appendingPathComponent("shijing").appendingPathExtension("txt")
        return try! String(contentsOf: url)
    }
    
    static func dullBoy() -> String {
        return String(repeating: "All work and no play makes Jack a dull boy\n", count: 1000)
    }
}
