import XCTest
@testable import Regex

class RegexTests: XCTestCase {
    
    func testPatternMatching() {
        switch "foo" {
        case try! Regex("f.o"):
            break
        default:
            XCTFail()
        }
    }
    
    
    static var allTests = [
        ("testPatternMatching", testPatternMatching),
    ]
}
