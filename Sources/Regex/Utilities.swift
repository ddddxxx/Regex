import Foundation

extension String {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
    
    subscript(nsRange: NSRange) -> Substring? {
        guard let range = Range(nsRange, in: self) else {
            return nil
        }
        return self[range]
    }
}
