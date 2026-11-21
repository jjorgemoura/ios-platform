---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Libraries are nonisolated by default; only the app defaults to MainActor

## Context and Problem Statement

Swift 6.2+ lets a module default to `@MainActor` isolation. That suits UI code but can force library work, such as parsing large FIT files, onto the main thread. Which default isolation does each module use?

## Decision Drivers

* Library work must not block the UI
* App code should stay simple
* Explicit isolation in public APIs

## Considered Options

* Libraries nonisolated by default; app uses default MainActor isolation
* Everything nonisolated
* Everything MainActor by default

## Decision Outcome

Chosen option: "Libraries nonisolated, app MainActor by default", because each module gets the default that fits its job.

### Consequences

* Good, because heavy work stays off the main thread and app code needs fewer annotations
* Bad, because two isolation models to keep in mind

### Confirmation

Library `Package.swift` files do not set default MainActor isolation; review of public API isolation.

## Pros and Cons of the Options

### Libraries nonisolated, app MainActor

* Good, because library work (parsing, decoding, location processing) runs off the main thread unless a caller asks for it
* Good, because consumers who do not default to MainActor can call library APIs without hopping actors
* Good, because app code, mostly UI, needs few `@MainActor` annotations
* Bad, because there are two isolation models to keep in mind when moving code between a library and the app
* Bad, because library types that UI code holds must still be designed `Sendable` or explicitly isolated

### Everything nonisolated

* Good, because one model everywhere, matching the Swift default
* Bad, because app and UI code needs `@MainActor` annotations everywhere and produces more concurrency diagnostics

### Everything MainActor

* Good, because one model everywhere, the simplest to write UI against
* Bad, because heavy library work runs on the main thread unless every such API is marked `nonisolated` or `@concurrent`
* Bad, because public library APIs become MainActor-isolated, which forces that isolation on every consumer, including server and command-line code
## More Information

Related: ADR-0005.
