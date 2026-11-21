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

* Good, because it is the convention in the Swift package ecosystem, so `from: "1.2.0"` maps directly to the tag
* Good, because releases are deliberate: a person chooses patch, minor or major
* Good, because there is no changelog file to maintain or to cause conflicts
* Bad, because release notes are only as good as the PR titles (GIT-3)
* Bad, because choosing the right bump depends on discipline

### SemVer with hand-written CHANGELOG

* Good, because release notes are written for consumers, not derived from PR titles
* Good, because the history is readable offline and in the package source
* Bad, because every change needs a changelog edit, which is easy to forget and conflicts across branches
* Bad, because it duplicates the GitHub Releases page

### SemVer, `v` prefix

* Good, because it is common across GitHub and other ecosystems
* Neutral, because SwiftPM accepts both `1.2.0` and `v1.2.0` tags
* Bad, because it is less common in the Swift ecosystem, and mixing styles across the libraries would be confusing

### Automated from commits

* Good, because there is no decision at release time: the bump and the notes come from Conventional Commit messages
* Bad, because a mistyped commit type produces the wrong version
* Bad, because it adds tooling (for example release-please or semantic-release) and its configuration to every repo
* Bad, because releases happen on every merge unless they are gated, which is less deliberate
## More Information

https://semver.org
