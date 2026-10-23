---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Use Xcode 27 and Swift 6.4, pinned per repository

## Context and Problem Statement

Builds must be reproducible locally and in CI. Which toolchain do we use, and how is the version fixed?

## Decision Drivers

* Use the latest stable Apple tooling
* Same version locally and on GitHub Actions runners
* Simple upgrade path once a year

## Considered Options

* Xcode 27 / Swift 6.4, pinned in `.xcode-version`
* Xcode 26.x / Swift 6.2, pinned
* Whatever Xcode the runner defaults to

## Decision Outcome

Chosen option: "Xcode 27 / Swift 6.4, pinned in `.xcode-version`", because it is the latest stable release and pinning prevents runner drift.

### Consequences

* Good, because builds are reproducible
* Bad, because the pin must be bumped manually in every repo (handled by sync)

### Confirmation

Packages declare `swift-tools-version: 6.4`; CI selects the Xcode in `.xcode-version`.

## Pros and Cons of the Options

### Xcode 27, pinned

* Good, because {TODO}
* Bad, because {TODO}

### Xcode 26.x, pinned

* Good, because {TODO}
* Bad, because {TODO}

### Runner default

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Xcode 27 released 14 September 2026; requires macOS Tahoe 26.6+ on Apple silicon. Review at each major Xcode release.
