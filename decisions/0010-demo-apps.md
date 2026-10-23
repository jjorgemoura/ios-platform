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

* Good, because {TODO}
* Bad, because {TODO}

### Separate per-platform projects

* Good, because {TODO}
* Bad, because {TODO}

### Generated project

* Good, because {TODO}
* Bad, because {TODO}

## More Information

{TODO}
