## __MODULE__

__DESCRIPTION__

Private monorepo of the apps to release on the App Store. Not synced from `ios-platform`
(`sync: false`): this file, the Makefile, `.gitignore` and `dependabot.yml` belong to this repo.
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
