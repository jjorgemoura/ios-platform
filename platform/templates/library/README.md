# __MODULE__

__DESCRIPTION__

[![Documentation](https://img.shields.io/badge/documentation-gray?logo=swift&logoColor=white)][docs]
[![CI](https://github.com/__OWNER__/__REPO__/actions/workflows/ci.yml/badge.svg)](https://github.com/__OWNER__/__REPO__/actions/workflows/ci.yml)
[![Swift versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F__OWNER__%2F__REPO__%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/__OWNER__/__REPO__)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F__OWNER__%2F__REPO__%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/__OWNER__/__REPO__)

  * [Overview](#overview)
  * [Quick start](#quick-start)
  * [Examples](#examples)
  * [Documentation](#documentation)
  * [Installation](#installation)
  * [Community](#community)
  * [License](#license)

## Overview

<!-- TODO: Why __MODULE__ exists and what makes it different. Two or three short paragraphs. -->

## Quick start

```swift
import __MODULE__

let library = __MODULE__()
print(library.greeting())
```

<!-- TODO: Walk through the common tasks, each with a short snippet. -->

## Examples

This repo includes a demo app in [`Examples/`](Examples) that exercises the library. Run
`make demo` to open it.

## Documentation

The latest documentation for __MODULE__'s APIs is available [here][docs].

## Installation

You can add __MODULE__ to an Xcode project by adding it as a package dependency.

> https://github.com/__OWNER__/__REPO__

If you want to use __MODULE__ in a [SwiftPM](https://swift.org/package-manager/) project, it's as
simple as adding it to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/__OWNER__/__REPO__", from: "0.0.1")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "__MODULE__", package: "__REPO__"),
```

## Community

If you want to discuss this library or have a question about how to use it to solve a particular
problem, the [discussions](https://github.com/__OWNER__/__REPO__/discussions) tab of this repo
is the best place to start. Bugs and feature requests go in
[issues](https://github.com/__OWNER__/__REPO__/issues).

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[docs]: https://swiftpackageindex.com/__OWNER__/__REPO__/documentation/__MODULE_LOWER__
