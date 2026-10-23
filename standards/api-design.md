# API Design Standard

## Purpose

Library public APIs are independent, documented and stable for consumers.

## Scope

Public and package-level symbols in every library.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| API-1 | MUST | No library depends on another library in this set |
| API-2 | MUST | Each library defines its own types; no shared Core package |
| API-3 | MUST | Third-party dependencies require an ADR |
| API-4 | MUST | Hardware access (location, microphone, speaker) sits behind a protocol |
| API-5 | SHOULD | Follow the Swift API Design Guidelines |
| API-6 | SHOULD | Keep the public surface minimal; prefer `internal` or `package` |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| API-1 | CI fails if another set library appears in `Package.resolved` | reusable `ci.yml` |
| API-2 | Review | PR |
| API-3 | Review: new dependency without ADR is rejected | PR |
| API-4 | Review | PR |
| API-5 | Review | PR |
| API-6 | Review | PR |

## Exceptions

{TODO}

## Rationale

* ADR-0002: Libraries never depend on each other

## Last reviewed

2026-10-23
