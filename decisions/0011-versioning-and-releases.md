---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Version with SemVer tags and Keep a Changelog

## Context and Problem Statement

Consumers depend on the libraries through SwiftPM version requirements. How are versions numbered, tagged and documented?

## Decision Drivers

* Follow SwiftPM, GitHub and community conventions
* Clear signal for breaking changes
* Low-effort releases

## Considered Options

* SemVer tags without `v` prefix, Keep a Changelog, GitHub Releases
* SemVer with `v` prefix
* Automated versioning from Conventional Commits

## Decision Outcome

Chosen option: "SemVer tags without `v` prefix, Keep a Changelog, GitHub Releases", because it is the SwiftPM convention and keeps releases deliberate. Stay on 0.x until each API settles.

### Consequences

* Good, because standard and predictable for consumers
* Bad, because changelog entries are written by hand

### Confirmation

`release.yml` refuses a tag without a matching `CHANGELOG.md` entry.

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

https://semver.org · https://keepachangelog.com
