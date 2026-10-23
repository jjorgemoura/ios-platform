---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Format code with Apple's swift-format (trial)

## Context and Problem Statement

All repositories need one consistent formatting style, applied automatically. Which formatter do we use?

## Decision Drivers

* Ships with the toolchain; no extra installation
* Integrated in Xcode
* Curiosity: compare against SwiftFormat used at work

## Considered Options

* Apple swift-format
* SwiftFormat (Nick Lockwood)

## Decision Outcome

Chosen option: "Apple swift-format", as a trial, because it ships with the toolchain. Review on 2027-01-31; fall back to SwiftFormat if it falls short.

### Consequences

* Good, because zero setup and official support
* Bad, because fewer rules and options than SwiftFormat

### Confirmation

CI runs `swift format lint --strict`; `.swift-format` is synced from `platform`.

## Pros and Cons of the Options

### swift-format

* Good, because {TODO}
* Bad, because {TODO}

### SwiftFormat

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Review date: 2027-01-31. Related: ADR-0008.
