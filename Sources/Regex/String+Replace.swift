import Foundation

extension String {
    
    public func replacingMatches<Template: StringProtocol>(of regex: Regex, with template: Template, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> String {
        return regex._regex.stringByReplacingMatches(in: self, options: options, range: range ?? fullRange, withTemplate: String(template))
    }
}
