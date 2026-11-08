#!/usr/bin/env bash
#
# create-library.sh — create a new library repo from platform/templates.
#
# Usage:
#   create-library.sh [--local DIR] [--protect] <repo-name> <ModuleName> ["Description"]
#   create-library.sh gpx-swift GPXSwift "Read, write, clean and enrich GPX files"
#
#   --local DIR   Only scaffold into DIR (must not exist). No GitHub, no registry change.
#                 Use it to try the template: run `make lint` and `make test` in DIR.
#   --protect     Also turn on branch protection for main (GIT-1, GIT-2). Off by default
#                 while the repos are being set up. See standards/ci.md for the checks.
#
# Steps:
#   1. copy templates/sync (files shared by every repo), then templates/library
#   2. build AGENTS.md: the shared block (templates/sync/AGENTS.md) above the library part
#   3. replace the __TOKENS__ in file contents and in file and folder names
#   4. git init and commit
#   5. (not with --local) gh repo create + push, repo settings, registry status
#
# Requirements: bash 3.2+, git, perl. Without --local also: gh (authenticated).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT/registry/repos.yml"
TEMPLATES="$ROOT/templates"
BEGIN_MARK="<!-- BEGIN platform (synced, do not edit) -->"
END_MARK="<!-- END platform -->"

LOCAL_DIR=""
PROTECT=false
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)   LOCAL_DIR="${2:?--local needs a directory}"; shift ;;
    --protect) PROTECT=true ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    *)         POSITIONAL+=("$1") ;;
  esac
  shift
done

if [[ ${#POSITIONAL[@]} -lt 2 ]]; then sed -n '2,22p' "$0"; exit 1; fi

NAME="${POSITIONAL[0]}"
MODULE="${POSITIONAL[1]}"
DESCRIPTION="${POSITIONAL[2]:-}"

[[ "$NAME"   =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "error: repo-name must be kebab-case" >&2; exit 1; }
[[ "$MODULE" =~ ^[A-Z][A-Za-z0-9]*$ ]]       || { echo "error: ModuleName must be UpperCamelCase" >&2; exit 1; }

OWNER="$(sed -n 's/^owner: *//p' "$REGISTRY" | head -n 1)"
[[ -n "$OWNER" && "$OWNER" != "YOUR_GITHUB_USERNAME" ]] || { echo "error: set owner in $REGISTRY" >&2; exit 1; }
HOLDER="$(git config user.name || true)"
[[ -n "$HOLDER" ]] || { echo "error: git config user.name is empty (used for the LICENSE)" >&2; exit 1; }
[[ -n "$DESCRIPTION" ]] || DESCRIPTION="TODO: one sentence describing $MODULE."

FULL="$OWNER/$NAME"
PLATFORM_SHA="$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"

log() { printf '[%s] %s\n' "$NAME" "$1"; }

if [[ -n "$LOCAL_DIR" ]]; then
  [[ ! -e "$LOCAL_DIR" ]] || { echo "error: $LOCAL_DIR already exists" >&2; exit 1; }
  DEST="$LOCAL_DIR"
else
  command -v gh >/dev/null || { echo "error: gh is required (brew install gh)" >&2; exit 1; }
  if gh repo view "$FULL" >/dev/null 2>&1; then
    echo "error: $FULL already exists" >&2; exit 1
  fi
  WORK="$(mktemp -d)"
  trap 'rm -rf "$WORK"' EXIT
  DEST="$WORK/$NAME"
fi

# 1. Copy the templates. sync/AGENTS.md is a block source, not a file: step 2 builds AGENTS.md.
log "scaffolding in $DEST"
mkdir -p "$DEST"
cp -R "$TEMPLATES/sync/." "$DEST/"
rm -f "$DEST/AGENTS.md"
cp -R "$TEMPLATES/library/." "$DEST/"

# 2. AGENTS.md = shared block + library part (the library part was copied as AGENTS.md).
LIBRARY_PART="$(mktemp)"
mv "$DEST/AGENTS.md" "$LIBRARY_PART"
{
  echo "$BEGIN_MARK"
  cat "$TEMPLATES/sync/AGENTS.md"
  echo "$END_MARK"
  echo
  cat "$LIBRARY_PART"
} > "$DEST/AGENTS.md"
rm -f "$LIBRARY_PART"

# 3. Tokens, in contents and then in names (deepest first, so parents are renamed last).
MODULE_LOWER="$(printf '%s' "$MODULE" | tr '[:upper:]' '[:lower:]')"
YEAR="$(date +%Y)"
export NAME MODULE MODULE_LOWER OWNER HOLDER DESCRIPTION YEAR

(
  cd "$DEST"
  while IFS= read -r -d '' f; do
    perl -pi -e '
      s/__MODULE_LOWER__/$ENV{MODULE_LOWER}/g;
      s/__MODULE__/$ENV{MODULE}/g;
      s/__REPO__/$ENV{NAME}/g;
      s/__OWNER__/$ENV{OWNER}/g;
      s/__YEAR__/$ENV{YEAR}/g;
      s/__HOLDER__/$ENV{HOLDER}/g;
      s/__DESCRIPTION__/$ENV{DESCRIPTION}/g;
    ' "$f"
  done < <(grep -rlI --null -e '__[A-Z_]*__' . || true)

  while IFS= read -r -d '' path; do
    base="$(basename "$path")"
    new="${base//__MODULE__/$MODULE}"
    [[ "$new" != "$base" ]] && mv "$path" "$(dirname "$path")/$new"
  done < <(find . -depth -name '*__MODULE__*' -print0)

  # Fail loudly if a token survived.
  if grep -rnI -e '__MODULE' -e '__REPO__' -e '__OWNER__' -e '__YEAR__' -e '__HOLDER__' \
       -e '__DESCRIPTION__' . ; then
    echo "error: tokens left (see above)" >&2
    exit 1
  fi
)

# 4. Git.
git -C "$DEST" init -q -b main
git -C "$DEST" add -A
git -C "$DEST" commit -q -m "chore: scaffold $NAME from ios-platform@$PLATFORM_SHA"

if [[ -n "$LOCAL_DIR" ]]; then
  log "done: $DEST (local only; nothing was pushed)"
  exit 0
fi

# 5. GitHub. Public: libraries are open source (ADR-0001).
log "creating $FULL"
gh repo create "$FULL" --public --source "$DEST" --remote origin --push --description "$DESCRIPTION"

log "applying settings"
gh repo edit "$FULL" \
  --enable-squash-merge \
  --enable-merge-commit=false \
  --enable-rebase-merge=false \
  --delete-branch-on-merge \
  --enable-wiki=false \
  --enable-discussions \
  --add-topic swift --add-topic swift-package --add-topic ios --add-topic macos

if $PROTECT; then
  log "protecting main"
  # TODO: set required_status_checks.contexts to the names listed in standards/ci.md.
  gh api -X PUT "repos/$FULL/branches/main/protection" --input - >/dev/null <<'JSON'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": { "required_approving_review_count": 0 },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
fi

# 6. Registry: mark the repo active, or add it.
if grep -q "^  - name: $NAME\$" "$REGISTRY"; then
  awk -v n="$NAME" '
    $0 == "  - name: " n { found = 1 }
    found && /^    status:/ { sub(/status: *[a-z]+/, "status: active"); found = 0 }
    { print }
  ' "$REGISTRY" > "$REGISTRY.tmp" && mv "$REGISTRY.tmp" "$REGISTRY"
else
  printf '  - name: %s\n    visibility: public\n    status: active\n    sync: true\n' "$NAME" >> "$REGISTRY"
fi
log "done: https://github.com/$FULL  (registry updated; commit platform)"
