# Concurrency Standard

## Purpose

Code is free of data races, checked by the compiler, and library work never blocks the main thread.

## Scope

All Swift code in libraries, demo apps and the app.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| CONC-1 | MUST | Swift 6 language mode with complete strict concurrency checking |
| CONC-2 | MUST | Public types are `Sendable`, or their documentation says why not |
| CONC-3 | MUST | `@unchecked Sendable` has a comment explaining the invariant that makes it safe |
| CONC-4 | MUST | Libraries do not use default MainActor isolation; the app does |
| CONC-5 | SHOULD | No `DispatchQueue` in new code; use actors and structured concurrency |
| CONC-6 | SHOULD | Long-running work exposes cancellation |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| CONC-1 | Compiler, warnings as errors | `Package.swift`, reusable `ci.yml` |
| CONC-2 | Compiler + review | PR |
| CONC-3 | SwiftLint custom rule | `.swiftlint.yml` |
| CONC-4 | Review | `Package.swift` |
| CONC-5 | SwiftLint custom rule | `.swiftlint.yml` |
| CONC-6 | Review | PR |

## Exceptions

{TODO}

## Rationale

* ADR-0005: Use Swift 6 language mode with complete strict concurrency
* ADR-0006: Libraries are nonisolated by default; only the app defaults to MainActor

## Last reviewed

2026-10-23
