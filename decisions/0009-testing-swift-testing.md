---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Use Swift Testing for unit and integration tests

## Context and Problem Statement

The libraries must be tested thoroughly: parsers against real files, GPS and audio logic without hardware. Which test framework and approach do we use?

## Decision Drivers

* Parameterised tests over fixture corpora
* Parallel execution and good async support
* UI tests for demo apps

## Considered Options

* Swift Testing for unit and integration; XCTest only for UI tests
* XCTest everywhere

## Decision Outcome

Chosen option: "Swift Testing, with XCTest only for UI tests", because it is the modern framework and suits parameterised fixture tests.

### Consequences

* Good, because concise, parallel, parameterised tests
* Bad, because two frameworks in demo app projects

### Confirmation

Library test targets import `Testing`, not `XCTest`; hardware-backed code sits behind protocols with fakes; coverage reported in CI.

## Pros and Cons of the Options

### Swift Testing

* Good, because {TODO}
* Bad, because {TODO}

### XCTest everywhere

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Fixture files live in `Tests/<Module>Tests/Fixtures/`.
