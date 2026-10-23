---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# Libraries never depend on each other

## Context and Problem Statement

The app consumes all five libraries one level deep. Libraries naturally share concepts such as coordinates and tracks. Should they share types through a common package, or stay fully independent?

## Decision Drivers

* Each library must be usable on its own by any consumer
* Avoid coupling release cycles
* Keep dependency graphs flat

## Considered Options

* Fully independent libraries; each owns its types; the app maps between them
* Shared `Core` package with common types
* Libraries may depend on each other where useful

## Decision Outcome

Chosen option: "Fully independent libraries", because it keeps every library reusable and releasable on its own.

### Consequences

* Good, because no library forces another on a consumer
* Bad, because similar types (e.g. a track point) are defined more than once and the app writes mapping code

### Confirmation

CI fails if a library's `Package.resolved` contains another library from this set.

## Pros and Cons of the Options

### Fully independent

* Good, because {TODO}
* Bad, because {TODO}

### Shared Core package

* Good, because {TODO}
* Bad, because {TODO}

### Inter-library dependencies allowed

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Related: ADR-0001.
