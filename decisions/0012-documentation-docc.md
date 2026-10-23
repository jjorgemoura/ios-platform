---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Document APIs with DocC, hosted on Swift Package Index

## Context and Problem Statement

Each public library needs browsable API documentation and articles. How is it written and hosted?

## Decision Drivers

* Official Apple tooling
* Free hosting for public packages
* Documentation checked in CI

## Considered Options

* DocC catalog per package, hosted by Swift Package Index
* DocC published to GitHub Pages
* Third-party generator (e.g. Jazzy)

## Decision Outcome

Chosen option: "DocC hosted by Swift Package Index", because it is official, free and needs only an `.spi.yml` file.

### Consequences

* Good, because no hosting to maintain
* Bad, because docs publishing depends on a third-party service

### Confirmation

CI builds documentation with warnings as errors; every public symbol has a doc comment.

## Pros and Cons of the Options

### DocC on Swift Package Index

* Good, because {TODO}
* Bad, because {TODO}

### DocC on GitHub Pages

* Good, because {TODO}
* Bad, because {TODO}

### Third-party generator

* Good, because {TODO}
* Bad, because {TODO}

## More Information

{TODO}
