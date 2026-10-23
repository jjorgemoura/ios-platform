---
status: proposed
date: 2026-10-23
decision-makers: Jorge
---

# License the libraries under MIT

## Context and Problem Statement

The libraries are public; the app built on them is closed-source and sold on the App Store. Which licence do the libraries use?

## Decision Drivers

* Compatible with a closed, paid app
* Simple and widely understood
* Encourage reuse by others

## Considered Options

* MIT
* Apache-2.0
* No licence (all rights reserved)

## Decision Outcome

Chosen option: "MIT", because it is the simplest permissive licence and common in the Swift community.

### Consequences

* Good, because anyone can reuse the code, including in the private app
* Bad, because no explicit patent grant

### Confirmation

Each library repo contains `LICENSE` (MIT) and declares it in the README.

## Pros and Cons of the Options

### MIT

* Good, because {TODO}
* Bad, because {TODO}

### Apache-2.0

* Good, because {TODO}
* Bad, because {TODO}

### No licence

* Good, because {TODO}
* Bad, because {TODO}

## More Information

Check the FIT protocol / SDK licence before publishing fit-swift (separate ADR).
