import Foundation

public struct MatchResult: Equatable, Hashable {
    
    public struct Capture: Equatable, Hashable {
        
        fileprivate enum Content: Equatable, Hashable {
            
            case valid(substring: Substring)
            
            case invalid(original: NSString)
            
            static func validate(string: String, range: NSRange) -> Content {
                if let r = Range(range, in: string) {
                    return .valid(substring: string[r])
                } else {
                    return .invalid(original: string as NSString)
                }
            }
        }
        
        fileprivate let content: Content
        
        public let range: NSRange
        
        public var string: String {
            switch content {
            case let .valid(substring):
                return String(substring)
            case let .invalid(original):
                return original.substring(with: range)
            }
        }
        
//        public var content: Substring? {
//            if case let .valid(substring) = _content else {
//                return substring
//            } else {
//                return nil
//            }
//        }
    }
    
    public let captures: [Capture?]
    
    init(result: NSTextCheckingResult, in string: String) {
        precondition(result.range.location != NSNotFound)
        captures = (0..<result.numberOfRanges).map { index in
            let nsRange = result.range(at: index)
            guard nsRange.location != NSNotFound else { return nil }
            return Capture(content: .validate(string: string, range: nsRange), range: nsRange)
        }
    }
    
    public var range: NSRange {
        return captures[0].unsafelyUnwrapped.range
    }
    
    public var string: String {
        return captures[0].unsafelyUnwrapped.string
    }
    
    public subscript(_ captureGroupIndex: Int) -> Capture? {
        return captures[captureGroupIndex]
    }
}
