# Architecture Decision Records

Decisions for the running-libraries project, in [MADR 4.0](https://adr.github.io/madr/) format.

- New decision: copy `adr-template.md` to the next number, `NNNN-short-title.md`.
- Accepted ADRs are never edited. To change one, write a new ADR and mark the old one `superseded by ADR-NNNN`.
- Status values: `proposed`, `accepted`, `rejected`, `deprecated`, `superseded by ADR-NNNN`.

| ADR | Title | Status |
| --- | --- | --- |
| [0000](0000-use-markdown-architectural-decision-records.md) | Use Markdown Architectural Decision Records | accepted |
| [0001](0001-separate-repositories.md) | Use separate repositories for platform, each library and the app | proposed |
| [0002](0002-independent-libraries.md) | Libraries never depend on each other | proposed |
| [0003](0003-toolchain-xcode-27-swift-6-4.md) | Use Xcode 27 and Swift 6.4, pinned per repository | proposed |
| [0004](0004-deployment-targets.md) | Libraries target the 26 releases; the app targets the 27 releases | proposed |
| [0005](0005-swift-6-strict-concurrency.md) | Use Swift 6 language mode with complete strict concurrency | proposed |
| [0006](0006-actor-isolation-defaults.md) | Libraries are nonisolated by default; only the app defaults to MainActor | proposed |
| [0007](0007-formatter-swift-format.md) | Format code with Apple's swift-format (trial) | proposed |
| [0008](0008-linter-swiftlint.md) | Lint with SwiftLint, semantic rules only | proposed |
| [0009](0009-testing-swift-testing.md) | Use Swift Testing for unit and integration tests | proposed |
| [0010](0010-demo-apps.md) | Each library ships a multiplatform demo app as a plain Xcode project | proposed |
| [0011](0011-versioning-and-releases.md) | Version with SemVer tags and Keep a Changelog | proposed |
| [0012](0012-documentation-docc.md) | Document APIs with DocC, hosted on Swift Package Index | proposed |
| [0013](0013-license-mit.md) | License the libraries under MIT | proposed |
| [0014](0014-agent-instruction-files.md) | Use AGENTS.md as the canonical agent instruction file | proposed |
