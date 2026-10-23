# Standards

The rules that apply now, one file per area. ADRs in `../decisions/` explain why; these files say what.

- Each file follows `standard-template.md`: Purpose, Scope, Rules, Enforcement, Exceptions, Rationale, Last reviewed.
- Every rule has an ID (e.g. `TEST-3`) to cite in reviews, lint messages and `AGENTS.md`.
- Levels follow RFC 2119: MUST, SHOULD, MAY.
- Standards are edited freely. A change that reverses a decision needs a new ADR first.
- Update "Last reviewed" whenever you review a file, even with no changes.

| Standard | Prefix | Covers |
| --- | --- | --- |
| [Toolchain](toolchain.md) | TOOL | Xcode and Swift versions |
| [Platforms](platforms.md) | PLAT | Deployment targets, platform table |
| [Concurrency](concurrency.md) | CONC | Swift 6, Sendable, isolation |
| [API design](api-design.md) | API | Independence, dependencies, public surface |
| [Code style](code-style.md) | STYLE | swift-format, SwiftLint |
| [Testing](testing.md) | TEST | Swift Testing, fixtures, coverage |
| [Demo apps](demo-apps.md) | DEMO | Demo app structure |
| [Documentation](documentation.md) | DOC | DocC, README |
| [Releases](releases.md) | REL | SemVer, changelog, licence |
| [Git workflow](git-workflow.md) | GIT | Branches, PRs, commits |
| [CI](ci.md) | CI | Reusable workflows, pinning |
| [Agents](agents.md) | AGENT | AGENTS.md, CLAUDE.md, skills |
