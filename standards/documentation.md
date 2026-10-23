# Documentation Standard

## Purpose

Every library is understandable from its README and its DocC documentation alone.

## Scope

README, CHANGELOG, DocC catalogs and doc comments in every library.

## Rules

| ID | Level | Rule |
| --- | --- | --- |
| DOC-1 | MUST | Every public symbol has a DocC comment |
| DOC-2 | MUST | Each package has a DocC catalog with an overview article |
| DOC-3 | MUST | README contains: purpose, installation, quick start, platforms, licence, link to DocC |
| DOC-4 | MUST | `.spi.yml` is present so Swift Package Index hosts the docs |
| DOC-5 | SHOULD | Non-trivial features have a DocC article or tutorial |

## Enforcement

| Rule | Check | Where |
| --- | --- | --- |
| DOC-1 | DocC build with warnings as errors | reusable `ci.yml` job `docs` |
| DOC-2 | DocC build | reusable `ci.yml` job `docs` |
| DOC-3 | Template + review | README |
| DOC-4 | Template | repo template |
| DOC-5 | Review | PR |

## Exceptions

{TODO}

## Rationale

* ADR-0012: Document APIs with DocC, hosted on Swift Package Index

## Last reviewed

2026-10-23
