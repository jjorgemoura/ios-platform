# Platforms Standard

## Purpose

Each library declares and builds exactly the platforms it supports.

## Scope

`Package.swift` of every library; the app's Xcode project.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| PLAT-1 | MUST | Libraries declare the 26 releases as minimum; the app declares the 27 releases |
| PLAT-2 | MUST | Each library declares all five platforms (iOS, macOS, watchOS, tvOS, visionOS) at the 26 release, except where the table below says No |
| PLAT-3 | MUST | Every declared platform builds in CI, one build per platform, and the CI `platforms` input matches `Package.swift` |
| PLAT-4 | SHOULD | Foundation-only libraries (gpx-swift, fit-swift) also build on Linux in CI |
| PLAT-5 | SHOULD | A library that cannot support a platform opts out in the table below and lists it under Exceptions |

| Library | iOS / iPadOS | macOS | watchOS | tvOS | visionOS | Linux (CI) |
| --- | --- | --- | --- | --- | --- | --- |
| gpx-swift | 26 | 26 | 26 | 26 | 26 | Yes |
| fit-swift | 26 | 26 | 26 | 26 | 26 | Yes |
| map-swift | 26 | 26 | 26 | 26 | 26 | No |
| gps-swift | 26 | 26 | 26 | 26 | 26 | No |
| audio-swift | 26 | 26 | 26 | 26 | 26 | No |

Only gpx-swift is built so far. Review the other rows when each library is created, and mark a platform No where its frameworks are unavailable (for example CoreLocation features on tvOS).

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| PLAT-1 | Review | `Package.swift` |
| PLAT-2 | Review against table | `Package.swift` |
| PLAT-3 | `build` matrix over the `platforms` input | reusable `ci.yml` |
| PLAT-4 | Linux build job | reusable `ci.yml` |
| PLAT-5 | Opt-outs recorded in this table | review |

## Exceptions

{TODO}

## Rationale

* ADR-0004: Libraries target the 26 releases; the app targets the 27 releases

## Last reviewed

2026-11-08
