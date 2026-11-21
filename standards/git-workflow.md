# Git Workflow Standard

## Purpose

`main` is always releasable and history is readable.

## Scope

All repositories.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| GIT-1 | MUST | `main` is protected; changes land through pull requests |
| GIT-2 | MUST | PRs merge only with green CI |
| GIT-3 | SHOULD | Commit messages and PR titles follow Conventional Commits |
| GIT-4 | SHOULD | PRs are squash-merged |
| GIT-5 | SHOULD | Branch names follow `type/short-description` (e.g. `feat/elevation-fill`) |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| GIT-1 | `Main` ruleset: PRs only, no force push or deletion | GitHub settings |
| GIT-2 | `Main` ruleset: required checks listed in the CI Standard | GitHub settings |
| GIT-3 | PR title check (`pr-title / check`) | reusable `pr-title.yml` |
| GIT-4 | Repo merge settings | GitHub settings |
| GIT-5 | Review | PR |

## Exceptions

* `ultra-tools` (GIT-1, GIT-2): private, and GitHub's free plan has no rulesets or branch
  protection for private repositories. Changes still go through PRs by convention, and CI runs
  on every PR to `main` (CI-5).
* Repository admins may bypass the `Main` ruleset in an emergency. A bypass also skips the
  required checks.

## Rationale

* No ADR: these rules follow common GitHub practice. Write one if a rule is contested.

## Last reviewed

2026-10-23
