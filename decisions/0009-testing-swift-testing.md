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

* Good, because parameterised tests (`@Test(arguments:)`) fit running one test over a corpus of fixture files
* Good, because tests run in parallel by default and support async natively
* Good, because `#expect` and `#require` give clearer failure messages than the `XCTAssert` family
* Good, because it runs on Linux, which the Foundation-only libraries test on (PLAT-4)
* Bad, because UI tests still need XCTest, so demo apps use two frameworks
* Bad, because parallel-by-default tests that share state must be serialised explicitly (`.serialized`)

### XCTest everywhere

* Good, because one framework everywhere, including UI tests
* Good, because it is mature and well documented
* Bad, because parameterised tests need loops or generated methods, and failures are harder to attribute to one fixture
* Bad, because Apple's new testing work goes into Swift Testing
## More Information

Fixture files live in `Tests/<Module>Tests/Fixtures/`.
