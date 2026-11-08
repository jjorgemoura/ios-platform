# Templates

Source of every library repo. Built from `gpx-swift`, which is the reference.

| Folder | Content | Used by |
| --- | --- | --- |
| `sync/` | Files that are identical in every repo: `.swiftlint.yml`, `.swift-format`, `.editorconfig`, `.gitignore`, `.xcode-version`, `Makefile`, `CLAUDE.md`, `.github/CODEOWNERS`, `.github/dependabot.yml`, and the shared block of `AGENTS.md`. No tokens. | `create-library.sh` for a new repo, `sync.sh` for existing ones |
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

To try the template without touching GitHub:

```
platform/scripts/create-library.sh --local /tmp/try try-lib TryLib "A test."
cd /tmp/try && make lint && make test
```

Check the template after changing it: scaffold with `--local`, then run `make lint`,
`make test`, `make docs` and build every platform and the demo (see `standards/ci.md`).
