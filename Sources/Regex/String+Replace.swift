//
//  String+Replace.swift
//
//  This file is part of Regex - https://github.com/ddddxxx/Regex
//  Copyright (C) 2019  Xander Deng. Licensed under the MIT License.
//

import Foundation

extension String {
    
    /// Returns a new string in which all matching regular expressions in a specified range of the string are
    /// replaced with the given template string.
    public func replacingMatches<Template: StringProtocol>(of regex: Regex, with template: Template, options: Regex.MatchingOptions = [], range: NSRange? = nil) -> String {
        return regex._regex.stringByReplacingMatches(in: self, options: options, range: range ?? fullNSRange, withTemplate: String(template))
    }
}
