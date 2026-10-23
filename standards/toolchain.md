# Toolchain Standard

## Purpose

Every repository builds with the same Xcode and Swift versions, locally and in CI.

## Scope

All library repositories, the app repository and the `platform` reusable workflows.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| TOOL-1 | MUST | Packages declare `swift-tools-version: 6.4` |
| TOOL-2 | MUST | Each repo contains `.xcode-version` with the pinned Xcode version |
| TOOL-3 | MUST | CI uses the Xcode version in `.xcode-version`, never the runner default |
| TOOL-4 | SHOULD | Toolchain upgrades happen once per major Xcode release, in all repos together |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| TOOL-1 | Build fails on mismatch | `Package.swift` |
| TOOL-2 | Synced from `platform/templates` | sync workflow |
| TOOL-3 | Explicit `xcode-select` step | reusable `ci.yml` |
| TOOL-4 | Review | upgrade PRs |

## Exceptions

{TODO}

## Rationale

* ADR-0003: Use Xcode 27 and Swift 6.4, pinned per repository

## Last reviewed

2026-10-23
