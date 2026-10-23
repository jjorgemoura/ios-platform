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

* Good, because {TODO}
* Bad, because {TODO}

### Swift 6, warnings allowed

* Good, because {TODO}
* Bad, because {TODO}

### Swift 5 mode

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Related: ADR-0006.
