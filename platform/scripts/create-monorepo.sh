#!/usr/bin/env bash
#
# create-monorepo.sh — scaffold the private apps monorepo from platform/templates.
#
# Usage:
#   create-monorepo.sh (--local DIR | --into DIR) <repo-name> <WorkspaceName> ["Description"]
#   create-monorepo.sh --into ~/Developer/myProjs/ultra-tools ultra-tools UltraTools "Private monorepo of my apps"
#
#   --local DIR   Only scaffold into DIR (must not exist) and commit there. Use it to try the
#                 template: run `make lint` and `make test` in DIR.
#   --into DIR    Scaffold into an existing clone of a private repo you already created on
#                 GitHub. DIR must be a git repo with a clean working tree whose only files are
#                 LICENSE and README.md (the template README replaces yours), and its origin
#                 must be <owner>/<repo-name>. The files are left staged: review with
#                 `git status`, then commit and push yourself. Marks the repo active in the
#                 registry.
#
# Steps:
#   1. copy templates/sync (files shared by every repo), then templates/monorepo on top, so the
#      monorepo Makefile, .gitignore and dependabot.yml replace the library ones
#   2. replace the __TOKENS__ in file contents and in file and folder names
#   3. stage (--into) or git init and commit (--local)
#
# Unlike libraries, the monorepo is not synced (sync: false in the registry) and its AGENTS.md is
# standalone: it has no synced block.
#
# Requirements: bash 3.2+, git, perl.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT/registry/repos.yml"
TEMPLATES="$ROOT/templates"

LOCAL_DIR=""
INTO_DIR=""
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)   LOCAL_DIR="${2:?--local needs a directory}"; shift ;;
    --into)    INTO_DIR="${2:?--into needs a directory}"; shift ;;
    -h|--help) sed -n '2,/^$/p' "$0"; exit 0 ;;
    *)         POSITIONAL+=("$1") ;;
  esac
  shift
done

if [[ ${#POSITIONAL[@]} -lt 2 ]]; then sed -n '2,/^$/p' "$0"; exit 1; fi
[[ -n "$LOCAL_DIR" || -n "$INTO_DIR" ]] || { echo "error: use --local or --into" >&2; exit 1; }
[[ -z "$LOCAL_DIR" || -z "$INTO_DIR" ]] || { echo "error: use --local or --into, not both" >&2; exit 1; }

NAME="${POSITIONAL[0]}"
MODULE="${POSITIONAL[1]}"
DESCRIPTION="${POSITIONAL[2]:-}"

[[ "$NAME"   =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "error: repo-name must be kebab-case" >&2; exit 1; }
[[ "$MODULE" =~ ^[A-Z][A-Za-z0-9]*$ ]]       || { echo "error: WorkspaceName must be UpperCamelCase" >&2; exit 1; }

OWNER="$(sed -n 's/^owner: *//p' "$REGISTRY" | head -n 1)"
[[ -n "$OWNER" && "$OWNER" != "YOUR_GITHUB_USERNAME" ]] || { echo "error: set owner in $REGISTRY" >&2; exit 1; }
[[ -n "$DESCRIPTION" ]] || DESCRIPTION="TODO: one sentence describing $MODULE."

FULL="$OWNER/$NAME"
PLATFORM_SHA="$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"

log() { printf '[%s] %s\n' "$NAME" "$1"; }

# Mark the repo active in the registry, or add it as a private, unsynced repo.
mark_active() {
  if grep -q "^  - name: $NAME\$" "$REGISTRY"; then
    awk -v n="$NAME" '
      $0 == "  - name: " n { found = 1 }
      found && /^    status:/ { sub(/status: *[a-z]+/, "status: active"); found = 0 }
      { print }
    ' "$REGISTRY" > "$REGISTRY.tmp" && mv "$REGISTRY.tmp" "$REGISTRY"
  else
    printf '  - name: %s\n    visibility: private\n    status: active\n    sync: false\n' "$NAME" >> "$REGISTRY"
  fi
}

if [[ -n "$LOCAL_DIR" ]]; then
  [[ ! -e "$LOCAL_DIR" ]] || { echo "error: $LOCAL_DIR already exists" >&2; exit 1; }
  DEST="$LOCAL_DIR"
else
  [[ -d "$INTO_DIR" ]] || { echo "error: $INTO_DIR is not a directory" >&2; exit 1; }
  DEST="$(cd "$INTO_DIR" && pwd)"
  [[ "$(git -C "$DEST" rev-parse --show-toplevel 2>/dev/null)" == "$DEST" ]] \
    || { echo "error: $DEST is not the root of a git repo" >&2; exit 1; }
  [[ -z "$(git -C "$DEST" status --porcelain)" ]] \
    || { echo "error: $DEST has uncommitted changes" >&2; exit 1; }
  EXTRA="$(git -C "$DEST" ls-files | grep -v -e '^LICENSE$' -e '^README\.md$' || true)"
  [[ -z "$EXTRA" ]] || { echo "error: $DEST already has files besides LICENSE and README.md:" >&2; echo "$EXTRA" >&2; exit 1; }
  ORIGIN="$(git -C "$DEST" remote get-url origin 2>/dev/null || true)"
  case "$ORIGIN" in
    */"$FULL"|*/"$FULL".git) ;;
    *) echo "error: origin of $DEST is '$ORIGIN', expected $FULL" >&2; exit 1 ;;
  esac
fi

# 1. Copy the templates. sync/AGENTS.md is a library block: the monorepo has its own AGENTS.md.
log "scaffolding in $DEST"
mkdir -p "$DEST"
cp -R "$TEMPLATES/sync/." "$DEST/"
rm -f "$DEST/AGENTS.md"
cp -R "$TEMPLATES/monorepo/." "$DEST/"

# 2. Tokens, in contents and then in names (deepest first, so parents are renamed last).
MODULE_LOWER="$(printf '%s' "$MODULE" | tr '[:upper:]' '[:lower:]')"
YEAR="$(date +%Y)"
export NAME MODULE MODULE_LOWER OWNER DESCRIPTION YEAR

(
  cd "$DEST"
  while IFS= read -r -d '' f; do
    perl -pi -e '
      s/__MODULE_LOWER__/$ENV{MODULE_LOWER}/g;
      s/__MODULE__/$ENV{MODULE}/g;
      s/__REPO__/$ENV{NAME}/g;
      s/__OWNER__/$ENV{OWNER}/g;
      s/__YEAR__/$ENV{YEAR}/g;
      s/__DESCRIPTION__/$ENV{DESCRIPTION}/g;
    ' "$f"
  done < <(grep -rlI --null --exclude-dir=.git -e '__[A-Z_]*__' . || true)

  while IFS= read -r -d '' path; do
    base="$(basename "$path")"
    new="${base//__MODULE__/$MODULE}"
    [[ "$new" != "$base" ]] && mv "$path" "$(dirname "$path")/$new"
  done < <(find . -depth -name '*__MODULE__*' -not -path './.git/*' -print0)

  # Fail loudly if a token survived.
  if grep -rnI --exclude-dir=.git -e '__MODULE' -e '__REPO__' -e '__OWNER__' -e '__YEAR__' \
       -e '__DESCRIPTION__' . ; then
    echo "error: tokens left (see above)" >&2
    exit 1
  fi
)

# 3. Git.
if [[ -n "$INTO_DIR" ]]; then
  git -C "$DEST" add -A
  mark_active
  log "scaffolded into $DEST and staged (nothing committed or pushed)"
  cat <<EOT

Next:
  cd $DEST
  git status && git diff --cached --stat
  make lint && make test            # optional check before the first push
  git commit -m "chore: scaffold $NAME from ios-platform@$PLATFORM_SHA"
  git push
Then, in the ios-platform clone: commit registry/repos.yml (the repo is now active), push, and
move the v1 tag so the CI caller finds ci-monorepo.yml.
EOT
  exit 0
fi

git -C "$DEST" init -q -b main
git -C "$DEST" add -A
git -C "$DEST" commit -q -m "chore: scaffold $NAME from ios-platform@$PLATFORM_SHA"
log "done: $DEST (local only; nothing was pushed, registry untouched)"
