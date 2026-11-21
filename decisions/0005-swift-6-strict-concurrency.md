---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Use Swift 6 language mode with complete strict concurrency

## Context and Problem Statement

All code is greenfield. How strict should concurrency checking be, and should warnings block merges?

## Decision Drivers

* Catch data races at compile time
* Learn and use the latest Swift concurrency model
* Libraries such as gps-swift and audio-swift are heavily concurrent

## Considered Options

* Swift 6 language mode, complete checking, warnings as errors in CI
* Swift 6 language mode, warnings allowed
* Swift 5 mode with targeted checking

## Decision Outcome

Chosen option: "Swift 6 mode, complete checking, warnings as errors in CI", because there is no legacy code to migrate.

### Consequences

* Good, because concurrency bugs surface before runtime
* Bad, because some Apple APIs need careful wrapping to satisfy `Sendable`

### Confirmation

CI builds with warnings treated as errors; `@unchecked Sendable` requires an explanatory comment (SwiftLint rule).

## Pros and Cons of the Options

### Swift 6, warnings as errors

* Good, because data races are compile errors, so they never reach main
* Good, because there is no legacy code, so starting strict costs nothing to migrate
* Good, because it gives the clearest signal for libraries that are heavily concurrent (gps-swift, audio-swift)
* Bad, because an Apple framework that is not yet annotated for `Sendable` needs wrapping, `@preconcurrency` or `nonisolated(unsafe)` before it builds
* Bad, because a new compiler release can add warnings that block merges until they are fixed

### Swift 6, warnings allowed

* Good, because the same compile-time race checking, without warnings blocking work
* Bad, because warnings accumulate and get ignored, so they stop being a signal
* Bad, because deprecations and new diagnostics go unnoticed until they become errors in a later Swift version

### Swift 5 mode

* Good, because fewer compile errors from frameworks that are not yet annotated
* Bad, because data races are found at runtime, if at all
* Bad, because the code must be migrated to Swift 6 mode later, against the goal of using the latest concurrency model
## More Information

Related: ADR-0006.
