# Testing Standard

## Purpose

Every library is thoroughly tested without needing real hardware or real races.

## Scope

Library test targets and demo app UI tests.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| TEST-1 | MUST | Unit and integration tests use Swift Testing |
| TEST-2 | MUST | XCTest is used only for demo app UI tests |
| TEST-3 | MUST | Every public API has tests |
| TEST-4 | MUST | Parsers have a fixture corpus of real files in `Tests/<Module>Tests/Fixtures/` |
| TEST-5 | MUST | Code using hardware is tested through fakes of its protocol |
| TEST-6 | SHOULD | Line coverage of library targets is at least 85% |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| TEST-1 | Review: library tests import `Testing` | PR |
| TEST-2 | Review | PR |
| TEST-3 | Review + coverage report | reusable `ci.yml` job `test` |
| TEST-4 | Review | PR |
| TEST-5 | Review | PR |
| TEST-6 | Coverage gate (warning only at first) | reusable `ci.yml` job `test` |

## Exceptions

{TODO}

## Rationale

* ADR-0009: Use Swift Testing for unit and integration tests

## Last reviewed

2026-10-23
