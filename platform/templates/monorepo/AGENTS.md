## __MODULE__

__DESCRIPTION__

Shared files (lint and format config, `.xcode-version`, `CLAUDE.md`, skills, `docs/agents/`)
are synced from `ios-platform`; edit them there. This file, the Makefile, `.gitignore` and
`dependabot.yml` belong to this repo and are never synced (ADR-0016).
The public libraries (gpx-swift, fit-swift, gps-swift, audio-swift, map-swift) live in their own
repos and are consumed as package dependencies.

The standards in `standards/` of `__OWNER__/ios-platform` still apply, except where this file
says otherwise.

### Layout
- `Packages/` holds all the logic, as local Swift packages (domain, storage, features, UI per
  platform). Each has its own `Package.swift`, `Sources/` and `Tests/`.
- `Apps/` holds the apps. An app is a thin shell: String catalog, Assets and config values
  (xcconfig), nothing else. No logic, no models, no views beyond what the entry point needs.
  `Apps/Package.swift` is empty on purpose, so Xcode doesn't list files twice.
- `__MODULE__.xcworkspace` opens everything. Build apps and packages through it.

### Rules
- Local packages may depend on each other (the "libraries never depend on libraries" rule,
  API-1, is for the public libraries). Keep the graph acyclic: shared code goes down into
  `Core`, platform UI goes up into feature packages.
- Packages declare the 27 releases (ADR-0004) on iOS, macOS, watchOS and visionOS. Every
  declared platform is built in CI.
- Swift 6 language mode with complete strict concurrency (CONC-1). Tests use Swift Testing.
- Platform-specific UI and features go in separate packages (for example per platform or per
  paid feature), so an app target links only what it ships.
- Work starts from a GitHub issue: a spec for a feature, a repro for a bug. The PR closes it
  with `Closes #<n>` (FLOW-1, FLOW-2, FLOW-5). App releases go through TestFlight with the
  privacy manifest reviewed (FLOW-7).

### Agent skills
- Issue tracker: GitHub issues, through `gh`. See `docs/agents/issue-tracker.md`.
- Triage labels: the five defaults. See `docs/agents/triage-labels.md`.
- Domain docs: single-context, `GLOSSARY.md` at the repo root; ADRs and standards are central
  in `ios-platform`. See `docs/agents/domain.md`.

### Gotchas
- `make lint`, `make test` and `make build PLATFORM=<platform>` run over every package in
  `Packages/`. A new package is picked up automatically, but add it to
  `.github/dependabot.yml` if it has external dependencies, and to the workspace.
- SwiftLint caches results locally, so a stale cache can hide violations that CI finds.
  `make lint` skips the cache. For Xcode, run `rm -rf ~/Library/Caches/SwiftLint`.
- CI logic is not in this repo. `.github/workflows/ci.yml` is a thin caller of the reusable
  workflow in `__OWNER__/ios-platform`, pinned to a tag. Change CI there. It runs only on pull
  requests to `main` (CI-5).

### Verifying changes
- Run `make lint` and `make test` before pushing.
- For changes that touch platform code, run `make build PLATFORM=<platform>` for each platform
  the package declares.
