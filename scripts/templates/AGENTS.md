# Project rules (shared)

This block is synced from the `platform` repo. Edit it there, not here.

## Commands

- `make format` — format with swift-format
- `make lint` — swift-format lint + SwiftLint
- `make test` — run Swift Testing suites
- `make docs` — build DocC

## Rules

Follow the standards in the `platform` repo, in particular:

- CONC-1: Swift 6 language mode, complete strict concurrency
- API-1: never depend on another library in this set
- DOC-1: every public symbol has a DocC comment
- TEST-1: Swift Testing for unit and integration tests
