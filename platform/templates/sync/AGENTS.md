# Project rules (shared)

This block is synced from the `ios-platform` repo. Edit it there, not here.

The standards behind these rules live in `standards/` of `jjorgemoura/ios-platform`. Read the
relevant file there before changing how a library is built, tested, documented or released.

- Swift 6 language mode with complete strict concurrency (CONC-1).
- A library never depends on another library in this set (API-1).
- Every public symbol has a DocC comment (DOC-1).
- Unit and integration tests use Swift Testing (TEST-1).
- Work starts from a GitHub issue: a spec for a feature, a repro for a bug. The PR closes it
  with `Closes #<n>` (FLOW-1, FLOW-2, FLOW-5).

## Agent skills

### Issue tracker

Issues, specs and tickets are GitHub issues, through `gh`. See `docs/agents/issue-tracker.md`.

### Triage labels

The five default triage labels (`needs-triage`, `needs-info`, `ready-for-agent`,
`ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` at the repo root; ADRs and standards are central in
`ios-platform`. See `docs/agents/domain.md`.
