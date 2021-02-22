# Regex

Swift wrapper of NSRegularExpression

## Requirements

- Swift 5.1

## Installation

Add the project to your `Package.swift` file:

```swift
package.dependencies += [
    .package(url: "https://github.com/ddddxxx/Regex", .upToNextMinor("0.2.0"))
]
```

## Usage

### Quick Start

```swift
import Regex

let regex = Regex("(foo|bar)") // create from static string, crash if failed

let pattern = "(foo|bar)"
let _ = try! Regex(pattern) // create from dynamic string, throwing

let match = regex.firstMatch(in: "barbecue")
match![1]!.string // "bar"
```

## License

Semver is available under the MIT license. See the [LICENSE file](LICENSE).
