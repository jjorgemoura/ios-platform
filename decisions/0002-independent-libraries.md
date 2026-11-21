---
status: accepted
date: 2026-11-21
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

* Good, because each library can be adopted alone, with no transitive dependencies forced on the consumer
* Good, because each library is released on its own schedule, and a breaking change in one never cascades into another
* Good, because each library models the domain the way its format or framework needs (a GPX track point is not a FIT record)
* Bad, because similar types (coordinates, track points, durations) are defined several times
* Bad, because the app writes and tests mapping code between the libraries' types

### Shared Core package

* Good, because common types are defined once and the libraries interoperate without mapping
* Bad, because every library depends on `Core`, so a breaking change in `Core` forces a release of every library
* Bad, because `Core` tends to grow into a catch-all that suits no consumer exactly
* Bad, because consumers of one library also get `Core` and must resolve it against other versions in their graph

### Inter-library dependencies allowed

* Good, because a library can reuse another where the overlap is real (for example map-swift drawing gpx-swift tracks)
* Bad, because dependency graphs grow and version conflicts become possible for consumers
* Bad, because release cycles become coupled, and the dependency direction must be policed to avoid cycles
* Bad, because each case is a judgement call, with no clear rule for when a dependency is justified
## More Information

Related: ADR-0001.
