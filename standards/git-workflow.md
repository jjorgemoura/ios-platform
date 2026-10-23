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
| GIT-1 | Branch protection | GitHub settings |
| GIT-2 | Required status checks | GitHub settings |
| GIT-3 | PR title check | reusable workflow |
| GIT-4 | Repo merge settings | GitHub settings |
| GIT-5 | Review | PR |

## Exceptions

{TODO}

## Rationale

* {TODO: no ADR yet; add one if these rules are contested}

## Last reviewed

2026-10-23
