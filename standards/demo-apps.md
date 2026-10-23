# Demo Apps Standard

## Purpose

Each library has a demo app that exercises it in isolation for development, tuning and manual testing.

## Scope

The `Demo/` folder of every library repository.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| DEMO-1 | MUST | One multiplatform Xcode app in `Demo/`, plain `.xcodeproj`, no Tuist or XcodeGen |
| DEMO-2 | MUST | The demo consumes the library as a local package |
| DEMO-3 | MUST | The demo builds for iOS and macOS in CI |
| DEMO-4 | SHOULD | The demo covers every main feature listed in the library's spec |
| DEMO-5 | SHOULD | The demo includes sample data (e.g. bundled GPX/FIT files) so it works offline |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| DEMO-1 | Review | PR |
| DEMO-2 | Review | `Demo/*.xcodeproj` |
| DEMO-3 | Build job | reusable `ci.yml` job `build-demo` |
| DEMO-4 | Review | PR |
| DEMO-5 | Review | PR |

## Exceptions

{TODO}

## Rationale

* ADR-0010: Each library ships a multiplatform demo app as a plain Xcode project

## Last reviewed

2026-10-23
