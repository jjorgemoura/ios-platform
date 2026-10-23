---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Libraries target the 26 releases; the app targets the 27 releases

## Context and Problem Statement

The project should use the latest Apple technologies, but public libraries are more useful if they support slightly older systems. Which minimum OS versions do libraries and the app declare?

## Decision Drivers

* Use the newest APIs (Observation, Swift concurrency, latest CoreLocation)
* Wider reach for public libraries
* Minimal availability checks in code

## Considered Options

* Libraries: 26 releases (latest −1); app: 27 releases
* Everything on the 27 releases
* Everything on the 26 releases

## Decision Outcome

Chosen option: "Libraries on 26, app on 27", because the 26 releases already contain almost all required APIs and the app can adopt 27-only features freely.

### Consequences

* Good, because libraries serve more consumers
* Bad, because libraries may need `@available` checks for 27-only APIs

### Confirmation

`Package.swift` platforms match the platform table in the standards; CI builds each declared platform.

## Pros and Cons of the Options

### Libraries 26, app 27

* Good, because {TODO}
* Bad, because {TODO}

### All 27

* Good, because {TODO}
* Bad, because {TODO}

### All 26

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Platforms: iOS, iPadOS and macOS now; watchOS and visionOS later, when hardware is available for testing.
