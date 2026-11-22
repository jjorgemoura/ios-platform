# Architecture Decision Records

Decisions for the iOS platform (the libraries, the apps monorepo and this repo), in [MADR 4.0](https://adr.github.io/madr/) format.

- New decision: copy `adr-template.md` to the next number, `NNNN-short-title.md`.
- Proposed ADRs are drafts: edit them freely until they are accepted or rejected.
- Accepted ADRs are not edited, except for their status line and typo or link fixes. To change a decision, write a new ADR that supersedes it, and set the old one to `superseded by ADR-NNNN`.
- Status values: `proposed`, `accepted`, `rejected`, `deprecated`, `superseded by ADR-NNNN`.

| ADR | Title | Status |
| --- | --- | --- |
| [0000](0000-use-markdown-architectural-decision-records.md) | Use Markdown Architectural Decision Records | accepted |
| [0001](0001-separate-repositories.md) | Use separate repositories for platform, each library and the app | accepted |
| [0002](0002-independent-libraries.md) | Libraries never depend on each other | accepted |
| [0003](0003-toolchain-xcode-27-swift-6-4.md) | Use Xcode 27 and Swift 6.4, pinned per repository | accepted |
| [0004](0004-deployment-targets.md) | Libraries target the 26 releases; the app targets the 27 releases | accepted |
| [0005](0005-swift-6-strict-concurrency.md) | Use Swift 6 language mode with complete strict concurrency | accepted |
| [0006](0006-actor-isolation-defaults.md) | Libraries are nonisolated by default; only the app defaults to MainActor | accepted |
| [0007](0007-formatter-swift-format.md) | Format code with Apple's swift-format | accepted |
| [0008](0008-linter-swiftlint.md) | Lint with SwiftLint, semantic rules only | accepted |
| [0009](0009-testing-swift-testing.md) | Use Swift Testing for unit and integration tests | accepted |
| [0010](0010-demo-apps.md) | Each library ships a multiplatform demo app as a plain Xcode project | accepted |
| [0011](0011-versioning-and-releases.md) | Version with SemVer tags and generated release notes | accepted |
| [0012](0012-documentation-docc.md) | Document APIs with DocC, hosted on Swift Package Index | accepted |
| [0013](0013-license-mit.md) | License the libraries under MIT | accepted |
| [0014](0014-agent-instruction-files.md) | Use AGENTS.md as the canonical agent instruction file | accepted |
| [0015](0015-development-flow.md) | Use a six-phase development flow with GitHub issues as the spec | accepted |
| [0016](0016-sync-monorepo-with-exclusions.md) | Sync the apps monorepo too, except the files it owns | accepted |
