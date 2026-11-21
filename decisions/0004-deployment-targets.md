---
status: accepted
date: 2026-11-21
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

* Good, because the libraries work for consumers who still support the 26 releases
* Good, because the app uses 27-only APIs without availability checks
* Good, because the 26 releases already contain Observation, modern Swift concurrency and current CoreLocation APIs
* Bad, because libraries need `@available` checks for any 27-only API they use
* Bad, because there are two minimums to remember and review against

### All 27

* Good, because one minimum everywhere and no availability checks in the libraries
* Good, because the libraries can use every new API immediately
* Bad, because the public libraries exclude every consumer still supporting the 26 releases, during the first year after release

### All 26

* Good, because one minimum everywhere and the widest reach
* Bad, because the app needs availability checks or must give up 27-only features, though it has no older users to support
## More Information

Platforms: iOS, iPadOS, macOS, watchOS, tvOS and visionOS, all built in CI (see the Platforms Standard). Behaviour on watchOS, tvOS and visionOS is verified by building, not by running on devices.
