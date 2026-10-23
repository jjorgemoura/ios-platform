---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Use separate repositories for platform, each library and the app

## Context and Problem Statement

The project consists of five public libraries (gpx-swift, fit-swift, map-swift, gps-swift, audio-swift), a private paid App Store app, and shared specs and tooling. Should these live in one repository or several?

## Decision Drivers

* Libraries are public; the app is private and paid
* Each library needs its own demo app and release cycle
* Libraries are fully independent (see ADR-0002)

## Considered Options

* Separate repositories: `platform`, `.github`, one per library, one for the app
* Monorepo with all libraries and the app
* Public monorepo for libraries, private repo for the app

## Decision Outcome

Chosen option: "Separate repositories", because visibility, versioning and demo apps differ per library and the libraries share no code.

### Consequences

* Good, because each library is versioned, documented and consumed independently
* Bad, because shared files (lint config, workflows) must be synced across repos

### Confirmation

`platform/registry/repos.yml` lists every repository; the sync workflow keeps templated files identical.

## Pros and Cons of the Options

### Separate repositories

* Good, because {TODO}
* Bad, because {TODO}

### Monorepo

* Good, because {TODO}
* Bad, because {TODO}

### Library monorepo plus private app repo

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Related: ADR-0002.
