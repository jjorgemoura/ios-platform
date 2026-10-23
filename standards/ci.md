# CI Standard

## Purpose

CI logic lives once, in `platform`, and every repo runs the same checks.

## Scope

GitHub Actions workflows in `platform` and in every repository.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| CI-1 | MUST | Library repos call the reusable workflows in `platform`; they hold no CI logic of their own |
| CI-2 | MUST | Reusable workflows are referenced by tag or commit SHA, not `main` |
| CI-3 | MUST | CI jobs: `lint`, `test`, `build-demo`, `docs`; `release` on tags |
| CI-4 | MUST | Third-party actions are pinned to a commit SHA |
| CI-5 | SHOULD | The private app runs CI only on PRs to `main` to limit paid macOS minutes |
| CI-6 | SHOULD | Dependabot updates GitHub Actions and SwiftPM dependencies |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| CI-1 | Template `ci.yml` is a thin caller | repo template |
| CI-2 | Review | `.github/workflows/` |
| CI-3 | Required status checks | GitHub settings |
| CI-4 | Review | `.github/workflows/` |
| CI-5 | Workflow triggers | app repo `ci.yml` |
| CI-6 | `dependabot.yml` | repo template |

## Exceptions

{TODO}

## Rationale

* ADR-0001: Use separate repositories for platform, each library and the app

## Last reviewed

2026-10-23
