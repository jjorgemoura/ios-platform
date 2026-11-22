# Reusable workflows

Each diagram shows one workflow: its jobs, where they run, and how they depend on each other.
Jobs inside a workflow have no `needs:`, so they all start in parallel.

**Key:** 🐧 `ubuntu-latest` (in the `swift:6.4-noble` container where noted) ·  `inputs.runner`
(default `xcode-27`) · dashed border = conditional job · `×N` = matrix.

## `ci.yml`: library CI

```mermaid
flowchart LR
  start(["workflow_call<br/>module, platforms, linux, demo"])
  subgraph L["🐧 Linux · swift:6.4-noble"]
    lint["lint<br/>swift-format · SwiftLint · analyze<br/>libraries independent"]
    tl["test-linux<br/>swift test"]
  end
  subgraph M[" macOS · xcode-27"]
    build["build ×5<br/>iOS macOS watchOS tvOS visionOS"]
    test["test<br/>swift test + coverage"]
    demo["demo ×2<br/>iOS Simulator · macOS"]
    docs["docs<br/>make docs"]
  end
  start --> lint & tl & build & test & demo & docs
  tl -.- c1{{"if linux"}}
  demo -.- c2{{"if demo"}}
  docs -.- c3{{"if not pull_request"}}
  classDef cond stroke-dasharray:5 5
  class tl,demo,docs cond
```

## `ci-monorepo.yml`: monorepo CI

```mermaid
flowchart LR
  start(["workflow_call<br/>workspace, platforms"])
  subgraph L["🐧 Linux · swift:6.4-noble"]
    lint["lint<br/>swift-format · SwiftLint"]
  end
  subgraph M[" macOS · xcode-27"]
    build["build ×4<br/>make build: iOS macOS watchOS visionOS"]
    test["test<br/>make test"]
  end
  start --> lint & build & test
```

## `release.yml`: release

The caller runs `ci.yml` first, then this workflow, so a release only happens after CI passes.

```mermaid
flowchart LR
  start(["workflow_dispatch in caller<br/>bump: patch / minor / major"])
  ci[["ci.yml<br/>(caller job, main only)"]]
  subgraph L["🐧 Linux"]
    rel["release<br/>main only · next SemVer<br/>gh release create"]
  end
  start --> ci -->|needs| rel
```

## `pr-title.yml`: PR title and linked issue

```mermaid
flowchart LR
  start(["pull_request in caller"])
  subgraph L["🐧 Linux"]
    check["check<br/>Conventional Commit title"]
    issue["issue<br/>description references an issue<br/>chore · docs · ci · sync · Dependabot exempt"]
  end
  start --> check & issue
  check -.- c1{{"if pull_request"}}
  issue -.- c2{{"if pull_request"}}
  classDef cond stroke-dasharray:5 5
  class check,issue cond
```
