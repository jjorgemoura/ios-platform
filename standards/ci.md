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
| CI-4 | MUST | Actions owned by GitHub (`actions/*`) may be referenced by major tag; any other third-party action is pinned to a commit SHA |
| CI-5 | SHOULD | The private apps monorepo calls `ci-monorepo.yml` and runs CI only on PRs to `main` to limit paid macOS minutes |
| CI-6 | SHOULD | Dependabot updates GitHub Actions and SwiftPM dependencies |

## Usage

The reusable workflows live in `.github/workflows/` of this repo (`ci.yml`, `release.yml`,
`pr-title.yml`, `ci-monorepo.yml`) and the
shared `select-xcode` action in `.github/actions/`. Each header comment shows the caller to copy.
The `v1` tag moves forward with compatible changes; a breaking change to the inputs gets `v2`.
Workflows and the action reference each other as `@v1`, so a branch cannot be tried before it is
tagged unless you temporarily point those references at the branch.

Each library protects `main` with a repository ruleset named `Main` (GIT-1, GIT-2): changes land
through a PR, no approval is required (the only developer cannot approve their own PR), and the
PR merges only when the checks below pass. Repository admins may bypass the ruleset; keep that for
emergencies, because a bypass also skips the checks. `create-library.sh --protect` creates the
same ruleset for a new library.

A ruleset requires the job names as the caller reports them: the caller's job id, then the job
name from the reusable workflow.

| Check | Required | Note |
| --- | --- | --- |
| `ci / lint` | Yes | |
| `ci / test` | Yes | macOS tests |
| `ci / test-linux` | Yes | Skipped when `linux` is false; GitHub counts a skipped check as passing |
| `ci / build (iOS)` | Yes | One build check per platform in the `platforms` input |
| `ci / build (macOS)` | Yes | |
| `ci / build (watchOS)` | Yes | |
| `ci / build (tvOS)` | Yes | |
| `ci / build (visionOS)` | Yes | |
| `ci / demo (iOS Simulator)` | Yes | Skipped when `demo` is false |
| `ci / demo (macOS)` | Yes | Skipped when `demo` is false |
| `ci / docs` | No | Skipped on PRs; runs on `main` and before a release |
| `pr-title / check` | Yes | Separate `PR title` workflow (GIT-3), synced from `platform/templates/sync` |
| `pr-title / issue` | Yes | Same workflow: the description references an issue (FLOW-5) |

`ios-platform` uses the same ruleset without required checks, since it has no CI of its own.
`ultra-tools` has no ruleset: GitHub's free plan does not offer rulesets or branch protection
for private repositories (see Exceptions in the Git workflow Standard).

Renaming a job in the reusable workflow, or a caller job id, changes these names. Update this
table, the `Main` ruleset in every library and the ruleset in `create-library.sh` in the
same step.

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| CI-1 | Template `ci.yml` is a thin caller | repo template |
| CI-2 | Review | `.github/workflows/` |
| CI-3 | Required status checks | GitHub settings |
| CI-4 | Review; Dependabot updates tags and pinned SHAs | `.github/workflows/` |
| CI-5 | Workflow triggers | app repo `ci.yml` |
| CI-6 | `dependabot.yml` | repo template |

## Exceptions

None.

## Rationale

* ADR-0001: Use separate repositories for platform, each library and the app

## Last reviewed

2026-11-22
