# Templates

Source of every library repo. Built from `gpx-swift`, which is the reference.

| Folder | Content | Used by |
| --- | --- | --- |
| `sync/` | Files that are identical in every repo: `.swiftlint.yml`, `.swift-format`, `.editorconfig`, `.gitignore`, `.xcode-version`, `Makefile`, `CLAUDE.md`, `.github/CODEOWNERS`, `.github/dependabot.yml`, and the shared block of `AGENTS.md`. No tokens. | `create-library.sh` for a new repo, `sync.sh` for existing ones |
| `monorepo/` | The private apps monorepo scaffold: `Packages/` (starter `Core` and `Features`), `Apps/`, the workspace, a Makefile that loops over the packages, standalone `AGENTS.md`, `.gitignore`, `dependabot.yml` and the CI caller. Applied on top of `sync/`, so its files win. | `create-monorepo.sh` |
| `library/` | The scaffold only: `Package.swift`, sources, tests, README, LICENSE, the demo app, the workspace, `.spi.yml`, the thin CI callers and the library part of `AGENTS.md`. | `create-library.sh` |

Change a shared file in `sync/`, never in a library repo. A file that must differ per repo does
not belong in `sync/`.

## Tokens (in `library/`)

| Token | Replaced with | Example |
| --- | --- | --- |
| `__MODULE__` | Module name, in contents and in file and folder names | `GPXSwift` |
| `__MODULE_LOWER__` | Lower-case module name (Swift Package Index URLs) | `gpxswift` |
| `__REPO__` | Repository name | `gpx-swift` |
| `__OWNER__` | `owner` in `registry/repos.yml` | `jjorgemoura` |
| `__HOLDER__`, `__YEAR__` | LICENSE: `git config user.name` and the current year | |
| `__DESCRIPTION__` | One-sentence description | |

## Create a library

```
platform/scripts/create-library.sh gpx-swift GPXSwift "One sentence about the library"
```

This creates the public repo on GitHub, pushes the scaffold, applies the repo settings and marks
the repo active in the registry. It needs `gh` (`brew install gh`, then `gh auth login`).

If you already created the repo on GitHub and cloned it (only a `LICENSE` in it), scaffold into
the clone instead. This needs no `gh`; it stages the files and you commit and push:

```
platform/scripts/create-library.sh --into ~/Developer/myProjs/fit-swift fit-swift FITSwift "One sentence"
```

To try the template without touching GitHub:

```
platform/scripts/create-library.sh --local /tmp/try try-lib TryLib "A test."
cd /tmp/try && make lint && make test
```

Check the template after changing it: scaffold with `--local`, then run `make lint`,
`make test`, `make docs` and build every platform and the demo (see `standards/ci.md`).

## Create the monorepo

```
platform/scripts/create-monorepo.sh --into ~/Developer/myProjs/ultra-tools ultra-tools UltraTools "One sentence"
```

The repo is private and not synced (`sync: false`). The script needs a clone whose only files are
`LICENSE` and `README.md`, stages the scaffold and leaves the commit to you. CI calls
`ci-monorepo.yml@v1`, so move the `v1` tag after pushing a change to that workflow. Try the
template with `--local DIR`, then run `make lint`, `make test` and `make build PLATFORM=iOS`.
