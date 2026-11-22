---
status: accepted
date: 2026-11-22
decision-makers: Jorge
---

# Use a six-phase development flow with GitHub issues as the spec

## Context and Problem Statement

Coding agents can now run most of the development cycle, and several published skill sets cover
its phases (Matt Pocock's `skills`, Addy Osmani's `agent-skills`, Point-Free's `pfw`). Without a
defined flow, steps get skipped (no spec, no failing test for a bug, no evidence in the PR) and
artifacts are produced that nothing uses later. How many phases should the flow have, what does
each one hand to the next, and where do specs and tickets live?

## Decision Drivers

* One developer: every gate must catch a real mistake, not record a handoff between people
* Each phase produces an artifact the next phase actually uses
* Work can start mid-flow (a bug, a crash spike), not only from a new idea
* Fits the installed skills, which read and write an issue tracker
* Covers Apple apps, Swift libraries and the backends that support them

## Considered Options

* Eleven phases: Setup, Discover, Define, Design, Plan, Build, Verify, Review, Release, Operate, Evolve
* Six phases plus a one-time Setup: Shape, Design and plan, Build, Review, Release, Operate and learn
* No defined flow; rely on the skills alone

For where specs and tickets live:

* GitHub issues, tickets as sub-issues
* Markdown files in each repo (`docs/specs/`)

## Decision Outcome

Chosen option: "Six phases plus a one-time Setup", with specs and tickets in GitHub issues,
because it keeps the gates that matter (a spec before Build, a failing test for a bug, evidence
before merge, TestFlight and the privacy manifest before an app release) and drops the ones
that only make sense across a team. The flow and its rules are in
[`standards/development-flow.md`](../standards/development-flow.md).

Matt Pocock's skills are the process skills. They already publish specs and tickets to the issue
tracker (`to-spec`, `to-tickets`, `triage`, `wayfinder`). Addy Osmani's set is not installed
alongside them, because the two duplicate the spec, TDD and review commands. Point-Free's skills
are the Apple architecture layer.

### Consequences

* Good, because each phase has one clear gate artifact
* Good, because GitHub issues link specs, tickets, PRs and releases without extra tooling
* Good, because a gate on an issue or PR can later be checked by a GitHub workflow
* Bad, because specs live outside the repo, so an offline agent cannot read them
* Bad, because most rules are checked in review until the automated checks exist

### Confirmation

The rules in `standards/development-flow.md` (FLOW-1 to FLOW-8), checked in review now, with
automated checks for FLOW-5 and FLOW-7 planned.

## Pros and Cons of the Options

### Eleven phases

* Good, because each activity is named and visible
* Bad, because Setup happens once per repo, not once per piece of work
* Bad, because Discover only exists to produce the spec, Plan follows Design directly, Verify is
  done during Build with TDD and CI, and Evolve produces the same output as Operate (new issues)
* Bad, because each extra gate is friction for one developer with no one to hand off to

### Six phases plus Setup

* Good, because every merged phase still produces an artifact (research ends in the spec, the
  device matrix runs in CI during Build, the retro files issues)
* Good, because small changes skip phases cleanly: a bug skips Design and plan
* Bad, because Design and plan holds two kinds of work (decisions and tickets); split it if
  that gets in the way

### No defined flow

* Good, because there is nothing to maintain
* Bad, because skills are advisory: nothing stops a step being skipped

### Specs in GitHub issues

* Good, because the installed skills already write to an issue tracker
* Good, because sub-issues and blocking links model tickets natively
* Bad, because specs are not versioned with the code

### Specs as Markdown in each repo

* Good, because specs are versioned and readable offline
* Bad, because tickets, blocking and status would need a local convention the skills do not share

## More Information

Gaps that no installed skill covers yet, to be written as shared skills in
`platform/templates/sync/.claude/skills/`:

* `xcode-test-matrix`: UI tests, snapshot tests and the device and OS matrix (Build)
* `a11y-hig-audit`: accessibility and HIG review (Review)
* `privacy-manifest-check`: privacy manifest and required-reason APIs (Release, FLOW-7)
* `testflight-release`: signing, TestFlight, App Store Connect metadata (Release)
* `metrickit-triage`: MetricKit and Xcode Organizer crashes into issues (Operate and learn)

Each repo also needs `setup-matt-pocock-skills` run once so the skills use GitHub issues and its
labels (Setup).

Review this decision after the first feature in `ultra-tools` has gone through all six phases.
