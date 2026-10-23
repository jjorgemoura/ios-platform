# Releases Standard

## Purpose

Releases are predictable for consumers and every change is traceable.

## Scope

Tags, CHANGELOG and GitHub Releases in every library repository.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| REL-1 | MUST | Versions follow SemVer; tags have no `v` prefix (`1.2.0`) |
| REL-2 | MUST | Each release has a CHANGELOG entry in Keep a Changelog format |
| REL-3 | MUST | Each tag has a matching GitHub Release |
| REL-4 | MUST | Breaking changes bump the major version (the minor version while on 0.x) |
| REL-5 | SHOULD | Libraries stay on 0.x until the API has settled |
| REL-6 | MUST | Licence is MIT, in `LICENSE` |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| REL-1 | Tag pattern check | reusable `release.yml` |
| REL-2 | Release refused without matching entry | reusable `release.yml` |
| REL-3 | Created by workflow | reusable `release.yml` |
| REL-4 | Review | release PR |
| REL-5 | Review | release PR |
| REL-6 | Template | repo template |

## Exceptions

{TODO}

## Rationale

* ADR-0011: Version with SemVer tags and Keep a Changelog
* ADR-0013: License the libraries under MIT

## Last reviewed

2026-10-23
