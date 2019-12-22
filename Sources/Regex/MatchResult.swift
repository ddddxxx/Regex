import Foundation

/// `MatchResult` represents a single match of a regex.
public struct MatchResult: Equatable, Hashable {
    
    /// `Capture` represents a captured string for a single match.
    public struct Capture: Equatable, Hashable {
        
        fileprivate enum Content: Equatable, Hashable {
            
            /// Valid captured substring.
            case valid(substring: Substring)
            
            /// Captured string breaks extended grapheme cluster thus the substring cannot be formed.
            ///
            /// The original string is stored for later slicing.
            case invalid(original: NSString)
            
            static func validate(string: String, range: NSRange) -> Content {
                if let r = Range(range, in: string) {
                    return .valid(substring: string[r])
                } else {
                    return .invalid(original: string as NSString)
                }
            }
        }
        
        /// Captured content.
        fileprivate let content: Content
        
        /// The matching range.
        public let range: NSRange
        
        /// The matched string.
        public var string: String {
            switch content {
            case let .valid(substring):
                return String(substring)
            case let .invalid(original):
                return original.substring(with: range)
            }
        }
        
        /*
        public var content: Substring? {
            if case let .valid(substring) = _content else {
                return substring
            } else {
                return nil
            }
        }
         */
    }
    
    /// A group of captured strings for a single match.
    ///
    /// The 0th capture always corresponds to the entire match. A capture group might be `nil` If it didn't
    /// participate in the match.
    public let captures: [Capture?]
    
    init(result: NSTextCheckingResult, in string: String) {
        precondition(result.range.location != NSNotFound)
        captures = (0..<result.numberOfRanges).map { index in
            let nsRange = result.range(at: index)
            guard nsRange.location != NSNotFound else { return nil }
            return Capture(content: .validate(string: string, range: nsRange), range: nsRange)
        }
    }
    
    /// The range of the entire match.
    public var range: NSRange {
        return captures[0].unsafelyUnwrapped.range
    }
    
    /// The entire matched string.
    public var string: String {
        return captures[0].unsafelyUnwrapped.string
    }
    
    public subscript(_ captureGroupIndex: Int) -> Capture? {
        return captures[captureGroupIndex]
    }
}
