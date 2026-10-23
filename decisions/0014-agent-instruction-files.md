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

* Good, because {TODO}
* Bad, because {TODO}

### CLAUDE.md only

* Good, because {TODO}
* Bad, because {TODO}

### Per-agent files

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Initial shared skills: `add-public-api`, `cut-release`.
