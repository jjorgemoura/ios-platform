# Agents Standard

## Purpose

Coding agents get the same rules, commands and context as a human contributor, from one source.

## Scope

`AGENTS.md`, `CLAUDE.md` and `.claude/skills/` in every repository.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| AGENT-1 | MUST | `AGENTS.md` is the canonical instruction file |
| AGENT-2 | MUST | `CLAUDE.md` only imports `AGENTS.md` (`@AGENTS.md`) plus Claude-specific notes |
| AGENT-3 | MUST | `AGENTS.md` lists the build, test, lint and docs commands |
| AGENT-4 | MUST | `AGENTS.md` lists or links every MUST rule in these standards |
| AGENT-5 | MUST | Shared skills live in `.claude/skills/` and are synced from `platform` |
| AGENT-6 | SHOULD | Each repo adds a library-specific section below the synced base |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| AGENT-1 | Template | repo template |
| AGENT-2 | Template | repo template |
| AGENT-3 | Review | `AGENTS.md` |
| AGENT-4 | Review when standards change | `platform` PR |
| AGENT-5 | Sync | sync workflow |
| AGENT-6 | Review | `AGENTS.md` |

## Exceptions

{TODO}

## Rationale

* ADR-0014: Use AGENTS.md as the canonical agent instruction file

## Last reviewed

2026-10-23
