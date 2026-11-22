# ios-platform (home repo)

Home repo for my personal Swift work. Start here for anything that spans repos. For work inside
one repo, that repo's AGENTS.md is enough.

This repo holds what every repo shares:
- `standards/`: the rules in force, each with an ID (`CI-2`, `TEST-3`)
- `decisions/`: ADRs, the reasons behind the rules
- `platform/registry/repos.yml`: every repo and whether it is synced
- `platform/templates/` and `platform/scripts/`: scaffolds, plus `sync.sh` for shared files
- `.github/`: reusable workflows and actions that the other repos call at `@v1`

## Working across repos

- Edit shared files (lint config, Makefile, the shared AGENTS block, shared skills) in
  `platform/templates/sync/`, then run `platform/scripts/sync.sh`. Never edit them in a library.
- After changing a reusable workflow or action, move the `v1` tag.
- In child repos, work on a branch. Pushing is my call.

## Other Repos

- gpx-swift (public library: read and write GPX; the reference the templates come from):
  ~/Developer/myProjs/gpx-swift. Clone from https://github.com/jjorgemoura/gpx-swift.git if
  missing. Read its AGENTS.md first.
- fit-swift (public library: parse FIT files): ~/Developer/myProjs/fit-swift. Clone from
  https://github.com/jjorgemoura/fit-swift.git if missing. Read its AGENTS.md first.
- map-swift (public library: render points on a map): ~/Developer/myProjs/map-swift. Clone from
  https://github.com/jjorgemoura/map-swift.git if missing. Read its AGENTS.md first.
- gps-swift (public library: track location): ~/Developer/myProjs/gps-swift. Clone from
  https://github.com/jjorgemoura/gps-swift.git if missing. Read its AGENTS.md first.
- audio-swift (public library: spoken cues, playback, voice notes): ~/Developer/myProjs/audio-swift.
  Clone from https://github.com/jjorgemoura/audio-swift.git if missing. Read its AGENTS.md first.
- ultra-tools (private monorepo of my App Store apps; uses the libraries as package
  dependencies; not synced): ~/Developer/myProjs/ultra-tools. Clone from
  https://github.com/jjorgemoura/ultra-tools.git if missing. Read its AGENTS.md first: it
  overrides some standards.
- obsidian (private Obsidian vault, my notes and long-term memory): ~/Developer/myProjs/obsidian.
  Clone from https://github.com/jjorgemoura/obsidian.git if missing. Read-only unless I ask.
  When writing notes, follow its CLAUDE.md. Never touch its git.
