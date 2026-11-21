---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Use AGENTS.md as the canonical agent instruction file

## Context and Problem Statement

Coding agents (Claude Code now, possibly others later) need project rules, commands and conventions. Where do these instructions live so they stay in one place?

## Decision Drivers

* One source of truth for agent instructions
* Works with Claude Code today
* Open to other agents later without duplication

## Considered Options

* `AGENTS.md` canonical; `CLAUDE.md` imports it; skills in `.claude/skills/`
* `CLAUDE.md` only
* Per-agent files maintained separately

## Decision Outcome

Chosen option: "`AGENTS.md` canonical, `CLAUDE.md` imports it", because it serves Claude Code now and other agents later from one file. Copilot is deferred.

### Consequences

* Good, because instructions are written once
* Bad, because Claude-specific features still need `CLAUDE.md` or skills

### Confirmation

`AGENTS.md`, `CLAUDE.md` and shared skills are synced from `platform`; each repo adds only a library-specific section.

## Pros and Cons of the Options

### AGENTS.md canonical

* Good, because the instructions are written once and read by several agents (AGENTS.md is a cross-tool convention)
* Good, because Claude Code reads them through a one-line `@AGENTS.md` import in `CLAUDE.md`
* Good, because the shared block is synced by markers while each repo keeps its own section
* Bad, because Claude-specific features (skills, hooks, settings) still live in Claude-specific files
* Bad, because the import adds an indirection: editing `CLAUDE.md` by mistake has no effect

### CLAUDE.md only

* Good, because one file, with no indirection
* Bad, because other agents do not read it, so adding one later means duplicating or moving the content

### Per-agent files

* Good, because each file uses every feature of its agent
* Bad, because the same rules live in several files and drift apart
* Bad, because every new agent adds another file to sync to every repo
## More Information

Initial shared skills: `add-public-api`, `cut-release`.
