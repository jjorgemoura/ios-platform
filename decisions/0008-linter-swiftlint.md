---
status: accepted
date: 2026-11-21
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

* Good, because the two tools never fight: swift-format owns layout, SwiftLint owns code quality
* Good, because custom rules (for example on `@unchecked Sendable`) enforce project conventions
* Good, because a lint failure always means a real problem, not a style dispute
* Bad, because the disabled-rule list needs review whenever either tool adds rules

### Default rules

* Good, because there is nothing to configure
* Bad, because SwiftLint's default style rules conflict with swift-format's output, so formatted code fails lint
* Bad, because the defaults omit useful opt-in rules and include ones the project does not want

### No linter

* Good, because one tool less, with faster CI and no configuration to maintain
* Bad, because force unwraps, unchecked `Sendable` and complexity go unchecked except in review
* Bad, because there is nowhere to put project-specific rules
## More Information

Related: ADR-0007.
