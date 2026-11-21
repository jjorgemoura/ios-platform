---
status: accepted
date: 2026-11-21
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

* Good, because DocC is Apple's official tool, integrated in Xcode, with symbol links and articles
* Good, because Swift Package Index builds and hosts the docs for each release tag for free, with only `.spi.yml` to add
* Good, because the package is discoverable on Swift Package Index next to its docs and compatibility matrix
* Bad, because publishing depends on a third-party service and its build queue
* Bad, because there is less control over hosting, URL and build environment

### DocC on GitHub Pages

* Good, because full control over when docs publish and under which URL
* Bad, because a workflow must build and deploy the static site, and maintaining that workflow is work
* Bad, because versioned docs per release must be handled by the project itself

### Third-party generator

* Good, because Jazzy is mature, with flexible themes
* Bad, because it is a Ruby tool, so another toolchain to install
* Bad, because it is not integrated in Xcode, and the Swift ecosystem has moved to DocC
## More Information

Swift Package Index reads `documentation_targets` from `.spi.yml` in the repo root. Rules: the Documentation Standard (DOC).
