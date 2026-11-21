---
status: accepted
date: 2026-11-21
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

* Good, because it is short, widely understood and the most common licence for Swift packages
* Good, because it is compatible with a closed, paid app and with any consumer
* Good, because it asks only that the copyright notice is kept, so there is no friction for reuse
* Bad, because it has no explicit patent grant
* Bad, because anyone can use the code in closed products without contributing back

### Apache-2.0

* Good, because it is permissive like MIT and adds an explicit patent grant and patent retaliation clause
* Good, because it is the licence of Swift itself and many Apple open-source projects
* Bad, because it is longer, and asks consumers to keep a NOTICE file and mark changed files

### No licence

* Good, because the author keeps every right
* Bad, because no one can legally use, copy or modify the code, which defeats publishing it as a library
* Bad, because it discourages contributions and adoption
## More Information

Check the FIT protocol / SDK licence before publishing fit-swift (separate ADR).
