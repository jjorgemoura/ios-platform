---
status: accepted
date: 2026-11-21
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

`platform/registry/repos.yml` lists every repository; the sync script (`platform/scripts/sync.sh`) keeps templated files identical.

## Pros and Cons of the Options

### Separate repositories

* Good, because each library has its own visibility, issues, tags, releases and Swift Package Index page
* Good, because consumers clone and resolve only the library they use, with no unrelated history or files
* Good, because the private app never sits next to public code, so nothing private can leak through a public repo
* Bad, because shared configuration (lint, format, workflows, agent files) must be synced, which is why `sync.sh` and the templates exist
* Bad, because a change across libraries needs one PR per repo and cannot be tested atomically

### Monorepo

* Good, because one clone, one CI setup and atomic changes across every library and the app
* Good, because shared configuration lives once and needs no sync tooling
* Bad, because a repo is public or private as a whole, so the paid app cannot share it with public libraries
* Bad, because SwiftPM resolves a package from a repository's root `Package.swift` and its tags, so several independently versioned libraries in one repo do not fit how SwiftPM works

### Library monorepo plus private app repo

* Good, because the libraries share configuration and CI while the app stays private
* Good, because there are only two repositories to manage
* Bad, because the libraries share one tag line, so a release of one library is a release of all of them
* Bad, because consumers pull every library's sources and history to use one of them
* Bad, because the libraries share no code (ADR-0002), so the monorepo gives little beyond shared configuration, which the sync script already provides
## More Information

Related: ADR-0002.
