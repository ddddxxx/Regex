import Foundation

public struct MatchResult: Equatable, Hashable {
    
    public struct Capture: Equatable, Hashable {
        public let range: NSRange
        public let content: Substring?
    }
    
    public let captures: [Capture?]
    
    init(result: NSTextCheckingResult, in string: String) {
        guard result.range.location != NSNotFound else {
            captures = []
            return
        }
        captures = (0..<result.numberOfRanges).map { index in
            let nsRange = result.range(at: index)
            guard nsRange.location != NSNotFound else { return nil }
            return Capture(range: nsRange, content: string[nsRange])
        }
    }
}

extension MatchResult {
    
    public var range: NSRange {
        guard let first = captures.first else {
            return NSRange(location: NSNotFound, length: 0)
        }
        return first.unsafelyUnwrapped.range
    }
    
    public var content: Substring? {
        guard let first = captures.first else {
            return nil
        }
        return first.unsafelyUnwrapped.content
    }

    public var string: String {
        return content.map(String.init) ?? ""
    }
    
    public subscript(_ captureGroupIndex: Int) -> Capture? {
        return captures[captureGroupIndex]
    }
}

extension MatchResult.Capture {
    
    public var string: String {
        return content.map(String.init) ?? ""
    }
}
