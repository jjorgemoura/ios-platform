---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Version with SemVer tags and generated release notes

## Context and Problem Statement

Consumers depend on the libraries through SwiftPM version requirements. How are versions numbered, tagged and documented?

## Decision Drivers

* Follow SwiftPM, GitHub and community conventions
* Clear signal for breaking changes
* Low-effort releases

## Considered Options

* SemVer tags without `v` prefix, GitHub Releases with generated notes
* SemVer tags with a hand-written `CHANGELOG.md` (Keep a Changelog)
* SemVer with `v` prefix
* Automated versioning from Conventional Commits

## Decision Outcome

Chosen option: "SemVer tags without `v` prefix, GitHub Releases with generated notes", because it is the SwiftPM convention, keeps releases deliberate and needs no file to maintain. Stay on 0.x until each API settles.

### Consequences

* Good, because standard and predictable for consumers
* Bad, because release notes are only as good as the PR titles (see GIT-3)

### Confirmation

The reusable `release.yml` computes the next SemVer tag and creates the tag and a GitHub Release with generated notes in one step.

## Pros and Cons of the Options

### SemVer, no prefix

* Good, because {TODO}
* Bad, because {TODO}

### SemVer, `v` prefix

* Good, because {TODO}
* Bad, because {TODO}

### Automated from commits

* Good, because {TODO}
* Bad, because {TODO}

## More Information

https://semver.org
