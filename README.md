# Regex

Swift wrapper of NSRegularExpression

## Requirements

- Swift 5.1

## Installation

Add the project to your `Package.swift` file:

```swift
package.dependencies += [
    .package(url: "https://github.com/ddddxxx/Regex", .upToNextMinor("1.0.0"))
]
```

## Usage

### Quick Start

```swift
import Regex

let regex = Regex("(foo|bar)") // create from string literal, crash if failed

let pattern = "(foo|bar)"
let _ = try! Regex(pattern) // create from dynamic string, throwing

let match = regex.firstMatch(in: "barbecue")!
match.content // "bar" as Substring. It's encouraged to use this property instead of `string` for better performance.
match.string // "bar" as String
```

### Capture Groups

```swift
let regex = Regex(#"(\d{4})-(\d{2})-(\d{2})"#)
let match = regex.firstMatch(in: "2014-06-02")!
let year = Int(match[1]!.content)
let month = Int(match[2]!.content)
let day = Int(match[3]!.content)
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
