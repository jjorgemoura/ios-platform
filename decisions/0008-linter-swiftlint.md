---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Lint with SwiftLint, semantic rules only

## Context and Problem Statement

Beyond formatting, we want rules about code quality (force unwraps, unchecked Sendable, complexity). SwiftLint also has style rules that overlap swift-format. How do we lint without the tools conflicting?

## Decision Drivers

* Enforce project rules automatically, including custom ones
* No conflicts with the formatter
* Fast feedback in Xcode and CI

## Considered Options

* SwiftLint with style rules overlapping swift-format disabled
* SwiftLint with default rules
* No linter; formatter only

## Decision Outcome

Chosen option: "SwiftLint, semantic rules only", because it adds custom rules without fighting swift-format.

### Consequences

* Good, because project rules are enforced in CI
* Bad, because the rule list needs maintenance when either tool changes

### Confirmation

CI runs `swiftlint --strict`; `.swiftlint.yml` is synced from `platform`.

## Pros and Cons of the Options

### Semantic rules only

* Good, because {TODO}
* Bad, because {TODO}

### Default rules

* Good, because {TODO}
* Bad, because {TODO}

### No linter

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Related: ADR-0007.
