# Platforms Standard

## Purpose

Each library declares and builds exactly the platforms it supports.

## Scope

`Package.swift` of every library; the app's Xcode project.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| PLAT-1 | MUST | Libraries declare the 26 releases as minimum; the app declares the 27 releases |
| PLAT-2 | MUST | Each library declares only the platforms in the platform table below |
| PLAT-3 | MUST | Every declared platform builds in CI |
| PLAT-4 | SHOULD | Foundation-only libraries (gpx-swift, fit-swift) also build on Linux in CI |
| PLAT-5 | MAY | watchOS and visionOS are added when hardware is available for testing |

| Library | iOS / iPadOS | macOS | watchOS | visionOS | Linux (CI) |
| --- | --- | --- | --- | --- | --- |
| gpx-swift | 26 | 26 | Later | Later | Yes |
| fit-swift | 26 | 26 | Later | Later | Yes |
| map-swift | 26 | 26 | Later | Later | No |
| gps-swift | 26 | 26 (limited) | Later | No | No |
| audio-swift | 26 | 26 (limited) | Later | Later | No |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| PLAT-1 | Review | `Package.swift` |
| PLAT-2 | Review against table | `Package.swift` |
| PLAT-3 | Build matrix | reusable `ci.yml` |
| PLAT-4 | Linux build job | reusable `ci.yml` |
| PLAT-5 | New platform needs an update to this table | review |

## Exceptions

{TODO}

## Rationale

* ADR-0004: Libraries target the 26 releases; the app targets the 27 releases

## Last reviewed

2026-10-23
