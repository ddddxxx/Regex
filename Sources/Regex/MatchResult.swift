import Foundation

public struct MatchResult: Equatable, Hashable {
    
    public struct Capture: Equatable, Hashable {
        public let range: NSRange
        public let content: Substring
    }
    
    public let captures: [Capture?]
    
    init(result: NSTextCheckingResult, in string: String) {
        guard result.range.location != NSNotFound else {
            captures = []
            return
        }
        captures = (0..<result.numberOfRanges).map { index in
            let nsrange = result.range(at: index)
            guard nsrange.location != NSNotFound else { return nil }
            guard let r = Range(nsrange, in: string) else {
                // FIXME: regex detected an invalid position.
                return Capture(range: nsrange, content: "")
            }
            return Capture(range: nsrange, content: string[r])
        }
    }
}

extension MatchResult {
    
    public var range: NSRange {
        return captures.first!!.range
    }
    
    public var content: Substring {
        return captures.first!!.content
    }

    public var string: String {
        return String(content)
    }
    
    public subscript(_ captureGroupIndex: Int) -> Capture? {
        return captures[captureGroupIndex]
    }
}

extension MatchResult.Capture {
    
    public var string: String {
        return String(content)
    }
}
