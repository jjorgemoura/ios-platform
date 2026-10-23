# Code Style Standard

## Purpose

Code looks the same in every repository and style is never discussed in review.

## Scope

All Swift source and test files.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| STYLE-1 | MUST | Code is formatted with swift-format using the synced `.swift-format` |
| STYLE-2 | MUST | SwiftLint passes with zero warnings using the synced `.swiftlint.yml` |
| STYLE-3 | MUST | SwiftLint style rules that overlap swift-format are disabled |
| STYLE-4 | MUST | `.editorconfig` is present and synced |
| STYLE-5 | SHOULD | No force unwraps or force tries outside tests |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| STYLE-1 | `swift format lint --strict` | reusable `ci.yml` job `lint` |
| STYLE-2 | `swiftlint --strict` | reusable `ci.yml` job `lint` |
| STYLE-3 | Review of `.swiftlint.yml` | `platform/templates` |
| STYLE-4 | Sync | sync workflow |
| STYLE-5 | SwiftLint rules `force_unwrapping`, `force_try` | `.swiftlint.yml` |

## Exceptions

{TODO: e.g. `// swiftlint:disable:next <rule> — STYLE-5: reason`}

## Rationale

* ADR-0007: Format code with Apple's swift-format (trial)
* ADR-0008: Lint with SwiftLint, semantic rules only

## Last reviewed

2026-10-23
