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
| CI-3 | MUST | CI jobs: `lint`, `test`, `build` (one per platform), `demo`, `docs`. A release is a manual `workflow_dispatch` on `main` that runs CI first, then computes the next SemVer tag and creates the GitHub Release |
| CI-4 | MUST | Third-party actions are pinned to a commit SHA |
| CI-5 | SHOULD | The private app runs CI only on PRs to `main` to limit paid macOS minutes |
| CI-6 | SHOULD | Dependabot updates GitHub Actions and SwiftPM dependencies |

## Usage

The reusable workflows live in `.github/workflows/` of this repo (`ci.yml`, `release.yml`) and the
shared `select-xcode` action in `.github/actions/`. Each header comment shows the caller to copy.
The `v1` tag moves forward with compatible changes; a breaking change to the inputs gets `v2`.
Workflows and the action reference each other as `@v1`, so a branch cannot be tried before it is
tagged unless you temporarily point those references at the branch.

Branch protection (GIT-2) must require the job names as the caller reports them, for example
`ci / lint` and `ci / build (iOS)`.

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

2026-11-08
