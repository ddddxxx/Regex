# Regex

Type-safe regular expression.

## Requirements

- Swift 5.1

## Installation

Add the project to your `Package.swift` file:

```swift
package.dependencies += [
    .package(url: "https://github.com/ddddxxx/Regex", .upToNextMinor("2.0.0"))
]
```

## Usage

### Quick Start

```swift
import Regex

enum NumberRegex: TypedRegex {
    struct Result: MatchResultType3 { // `MatchResultType3` means 3 capture groups
        let capture1: Int
        let capture2: Int
        let capture3: Int
    }
    static let regex = Regex(#"(\d{4})-(\d{2})-(\d{2})"#)
}

let match = NumberRegex.firstMatch(in: "2014-06-02")!
match.capture1 
// => 2014
match.capture2 
// => 6
match.capture3 
// => 2
```

### Named Group

```swift
enum URLRegex: TypedRegex {
    struct Result: MatchResultType {
        // you need to specify `ExpressibleByMatchedString` for custom types
        // it automatically pick implementation from `LosslessStringConvertible` or `RawRepresentable` if possible
        enum Proto: String, ExpressibleByMatchedString { case http, https }
        let proto: Proto
        let host: String
        let port: Int?
        let path: String?
        let query: String? // use `Optional` type for optional capture group
    }
    static let regex = Regex(#"^(?<proto>.+)://(?<host>[^\s:/]+)(?::(?<port>[0-9]+))?(?<path>.+)?(?:\?(?<query>.+))$"#)
}
let match = URLRegex.firstMatch(in: "http://www.foo.com:123/bar")!
match.proto
// => Proto.http
match.host
// => "www.foo.com"
match.port
// => 123
match.path
// => "/bar"
match.query
// => nil
```

### Create

```swift
```swift
let regex = Regex("(foo|bar)") // create from string literal, crash if failed

let pattern = "(foo|bar)"
let _ = try! Regex(pattern) // create from dynamic string, throwing
```

### Replace

```swift
let regex = Regex(#"(\d{2})/(\d{2})/(\d{4})"#)
let date = "27/08/2019".replacingMatches(of: regex, with: "$3-$2-$1")
// 2019-08-27
```

### Pattern Match

```swift
let regex = Regex("#[a-fA-F0-9]{6}")
switch "#FF00FF" {
case regex:
    ...
}
```

## License

Semver is available under the MIT license. See the [LICENSE file](LICENSE).
