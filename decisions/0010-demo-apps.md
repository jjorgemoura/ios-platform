---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Each library ships a multiplatform demo app as a plain Xcode project

## Context and Problem Statement

The libraries are hard to tune in isolation (GPS battery profiles, audio mixing, map rendering). Each needs a demo app for development and manual testing. How is it structured?

## Decision Drivers

* Develop and tune each library in isolation
* Official Apple tooling only; no Tuist or XcodeGen
* Run on iOS and macOS from one target

## Considered Options

* One multiplatform Xcode app in `Demo/`, consuming the package as a local package
* Separate iOS and macOS demo projects
* Generated project (Tuist or XcodeGen)

## Decision Outcome

Chosen option: "One multiplatform Xcode app in `Demo/`", because it uses only official tooling and always builds against the local package source.

### Consequences

* Good, because library changes show up in the demo immediately
* Bad, because `.xcodeproj` merge conflicts are possible (low risk for a solo project)

### Confirmation

CI builds the demo app for iOS and macOS.

## Pros and Cons of the Options

### Multiplatform Xcode app

* Good, because one target runs on iOS and macOS, so one project and one scheme
* Good, because it uses only Xcode, with no extra tools to install or keep in sync
* Good, because the demo builds against the local package source through the workspace, so library changes show up immediately
* Bad, because `.xcodeproj` files merge poorly (low risk for a solo project)
* Bad, because platform differences in the demo need `#if os(...)` in shared code

### Separate per-platform projects

* Good, because each demo is tailored to its platform
* Bad, because two projects to maintain per library, with duplicated code and settings
* Bad, because twice the demo builds in CI

### Generated project

* Good, because projects are described in text files, so no `.xcodeproj` merge conflicts
* Good, because settings are easy to share across the five demo apps
* Bad, because it adds a third-party tool that must be installed and pinned, against the official-tooling-only driver
* Bad, because a generated project can lag behind new Xcode features
## More Information

Related: ADR-0009 (UI tests in demo apps). Rules: the Demo apps Standard (DEMO).
