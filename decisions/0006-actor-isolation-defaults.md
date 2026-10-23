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

* Good, because {TODO}
* Bad, because {TODO}

### Everything nonisolated

* Good, because {TODO}
* Bad, because {TODO}

### Everything MainActor

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Related: ADR-0005.
