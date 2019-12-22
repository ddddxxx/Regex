import Foundation

extension String {
    
    /// Returns a new string in which all matching regular expressions in a specified range of the string are
    /// replaced with the given template string.
    public func replacingMatches<Template: StringProtocol>(of regex: Regex, with template: Template, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> String {
        return regex._regex.stringByReplacingMatches(in: self, options: options, range: range ?? fullRange, withTemplate: String(template))
    }
}
