---
status: accepted
date: 2026-11-22
decision-makers: Jorge
---

# Sync the apps monorepo too, except the files it owns

## Context and Problem Statement

`sync.sh` copies the shared files in `platform/templates/sync/` into each repo, whole files
overwritten. The monorepo template replaces four of them with its own versions: `AGENTS.md`
(standalone: local packages depend on each other, which the library rule API-1 forbids),
`Makefile` (loops over `Packages/`), `.gitignore` and `.github/dependabot.yml`. And
`create-monorepo.sh` leaves out the two shared skills, which are about library work
(`add-public-api` for SemVer public API, `create-release` for the library Release workflow).
Syncing `ultra-tools` would have overwritten or added those, so it was set to `sync: false` when
it was created, with no ADR. Its copies of every other shared file (`.xcode-version`, lint and
format config, `CLAUDE.md`, `docs/agents/`) then drift from `platform`. How should the monorepo
get shared changes?

## Decision Drivers

* An Xcode bump or lint rule change reaches every repo, the apps included
* The monorepo keeps the files that must differ
* One mechanism for every repo, not a manual copy for one

## Considered Options

* Per-repo exclusions in `sync.sh`: `sync_exclude` in `registry/repos.yml`
* Keep `sync: false` and copy shared changes into `ultra-tools` by hand
* Make the shared files generic enough to fit both libraries and the monorepo

## Decision Outcome

Chosen option: "Per-repo exclusions", because the monorepo then gets every shared change
automatically and keeps the files it owns. `ultra-tools` is set to `sync: true` with
`sync_exclude` listing the four files and the two library skills' folders. An entry is a file or
a folder under `templates/sync`.

### Consequences

* Good, because shared changes reach `ultra-tools` through the same sync PR as the libraries
* Good, because the exclusion list documents which files the monorepo owns
* Bad, because the monorepo's `AGENTS.md` gets no shared block: rules added to the synced block
  (such as FLOW-1) must also be added to `templates/monorepo/AGENTS.md` and to `ultra-tools`
  by hand

### Confirmation

`sync.sh --dry-run ultra-tools` shows no change to the excluded files or skills;
`create-monorepo.sh` adds new monorepos with the same `sync_exclude` list.

## Pros and Cons of the Options

### Per-repo exclusions

* Good, because it is a small change to `sync.sh` and closes a known gap in it
* Good, because any future repo with its own version of a shared file uses the same mechanism
* Bad, because a new shared file that the monorepo should own must be added to the list

### Keep `sync: false`

* Good, because nothing changes
* Bad, because shared changes depend on remembering to copy them, and drift goes unnoticed

### Generic shared files

* Good, because no exclusions are needed
* Bad, because the Makefile and `AGENTS.md` differ in substance (one package against many,
  API-1), so a generic version would serve neither well

## More Information

Exclusions live in `platform/registry/repos.yml`; `sync.sh` reads them (see its header).
