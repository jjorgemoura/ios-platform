---
status: accepted
date: 2026-10-23
decision-makers: Jorge
---

# Use Markdown Architectural Decision Records (MADR)

## Context and Problem Statement

Decisions about tooling, platforms and architecture span six repositories and will be revisited over years. How do we record what was decided and why, so the reasoning survives and agents can read it?

## Decision Drivers

* Plain text, versioned with Git, readable on GitHub
* Low ceremony for a solo developer
* Readable by coding agents

## Considered Options

* MADR 4.0
* Michael Nygard's original ADR format
* Notes in a wiki or a single document

## Decision Outcome

Chosen option: "MADR 4.0", because it is structured enough to compare options, lightweight, and widely used.

### Consequences

* Good, because every decision has a stable number, status and history
* Bad, because small decisions add a file each

### Confirmation

Every file in `decisions/` follows `adr-template.md`; the index in `README.md` lists it.

## Pros and Cons of the Options

### MADR 4.0

* Good, because it records options and trade-offs, not only the outcome
* Bad, because more sections to fill than Nygard's format

### Nygard ADR

* Good, because minimal
* Bad, because no structured place for alternatives

### Wiki or single document

* Good, because easy to start
* Bad, because no per-decision history or status

## More Information

* https://adr.github.io/madr/
* Accepted ADRs are never edited; a new ADR supersedes them.
