---
status: accepted
date: 2026-11-21
decision-makers: Jorge
---

# Format code with Apple's swift-format

## Context and Problem Statement

All repositories need one consistent formatting style, applied automatically. Which formatter do we use?

## Decision Drivers

* Ships with the toolchain; no extra installation
* Integrated in Xcode

## Considered Options

* Apple swift-format
* SwiftFormat (Nick Lockwood)

## Decision Outcome

Chosen option: "Apple swift-format", because it is the official formatter and ships with the toolchain, so every machine and CI runner already has it at the same version as the compiler.

### Consequences

* Good, because zero setup and official support
* Bad, because fewer rules and options than SwiftFormat

### Confirmation

CI runs `swift format lint --strict`; `.swift-format` is synced from `platform`.

## Pros and Cons of the Options

### swift-format

* Good, because it ships with the Swift toolchain (`swift format`), so CI and every machine already have it, at the same version as the compiler
* Good, because Apple maintains it and it follows the language closely
* Good, because it has a `lint` mode with `--strict` for CI
* Bad, because it has fewer rules and options than SwiftFormat, so some style preferences cannot be expressed
* Bad, because it is slower than SwiftFormat on large code bases

### SwiftFormat

* Good, because it has a large rule set, many options, and is mature and widely used in the community
* Good, because it is already familiar from work
* Bad, because it is an extra tool to install and pin in CI and on every machine
* Bad, because a third-party tool can lag behind new Swift syntax
## More Information

Related: ADR-0008.
