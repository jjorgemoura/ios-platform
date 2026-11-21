---
status: accepted
date: 2026-11-21
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

* Good, because Swift 6.4 and the 27 SDKs are available everywhere, including the newest concurrency and language features
* Good, because the pin makes local and CI builds use the same compiler, so a runner image update cannot change results
* Good, because one `.xcode-version` file, synced to every repo, is the single place to upgrade
* Bad, because the pinned version must exist on the CI runner image, so CI breaks if the runner image drops it
* Bad, because consumers on Xcode 26 cannot build packages that declare `swift-tools-version: 6.4`

### Xcode 26.x, pinned

* Good, because a mature toolchain with more consumers already on it, so the libraries reach more people
* Good, because runner images support it widely
* Bad, because Swift 6.4 language and concurrency features are not available
* Bad, because the project would upgrade almost immediately anyway, since the app targets the 27 releases (ADR-0004)

### Runner default

* Good, because there is nothing to maintain
* Bad, because the compiler changes whenever GitHub updates the runner image, so builds are not reproducible
* Bad, because local and CI toolchains can differ, so a build passes locally and fails in CI (or the reverse)
## More Information

Xcode 27 released 14 September 2026; requires macOS Tahoe 26.6+ on Apple silicon. Review at each major Xcode release.
