#!/usr/bin/env bash
#
# create-library.sh — create a new library repo from platform/templates.
#
# Usage:
#   create-library.sh [--local DIR | --into DIR] [--protect] <repo-name> <ModuleName> ["Description"]
#   create-library.sh gpx-swift GPXSwift "Read, write, clean and enrich GPX files"
#
#   --local DIR   Only scaffold into DIR (must not exist). No GitHub, no registry change.
#                 Use it to try the template: run `make lint` and `make test` in DIR.
#   --into DIR    Scaffold into an existing clone of a repo you already created on GitHub.
#                 DIR must be a git repo with a clean working tree whose only file is
#                 LICENSE, and its origin must be <owner>/<repo-name>. The files are left
#                 staged: review with `git status`, then commit and push yourself. No gh.
#                 Marks the repo active in the registry.
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
# Requirements: bash 3.2+, git, perl. Without --local or --into also: gh (authenticated).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT/registry/repos.yml"
TEMPLATES="$ROOT/templates"
BEGIN_MARK="<!-- BEGIN platform (synced, do not edit) -->"
END_MARK="<!-- END platform -->"

LOCAL_DIR=""
INTO_DIR=""
PROTECT=false
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)   LOCAL_DIR="${2:?--local needs a directory}"; shift ;;
    --into)    INTO_DIR="${2:?--into needs a directory}"; shift ;;
    --protect) PROTECT=true ;;
    -h|--help) sed -n '2,/^$/p' "$0"; exit 0 ;;
    *)         POSITIONAL+=("$1") ;;
  esac
  shift
done

if [[ ${#POSITIONAL[@]} -lt 2 ]]; then sed -n '2,/^$/p' "$0"; exit 1; fi

NAME="${POSITIONAL[0]}"
MODULE="${POSITIONAL[1]}"
DESCRIPTION="${POSITIONAL[2]:-}"

[[ -z "$LOCAL_DIR" || -z "$INTO_DIR" ]] || { echo "error: use --local or --into, not both" >&2; exit 1; }
[[ -z "$INTO_DIR" ]] || ! $PROTECT || { echo "error: --protect needs the GitHub mode" >&2; exit 1; }

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

# Mark the repo active in the registry, or add it.
mark_active() {
  if grep -q "^  - name: $NAME\$" "$REGISTRY"; then
    awk -v n="$NAME" '
      $0 == "  - name: " n { found = 1 }
      found && /^    status:/ { sub(/status: *[a-z]+/, "status: active"); found = 0 }
      { print }
    ' "$REGISTRY" > "$REGISTRY.tmp" && mv "$REGISTRY.tmp" "$REGISTRY"
  else
    printf '  - name: %s\n    visibility: public\n    status: active\n    sync: true\n' "$NAME" >> "$REGISTRY"
  fi
}

if [[ -n "$LOCAL_DIR" ]]; then
  [[ ! -e "$LOCAL_DIR" ]] || { echo "error: $LOCAL_DIR already exists" >&2; exit 1; }
  DEST="$LOCAL_DIR"
elif [[ -n "$INTO_DIR" ]]; then
  [[ -d "$INTO_DIR" ]] || { echo "error: $INTO_DIR is not a directory" >&2; exit 1; }
  DEST="$(cd "$INTO_DIR" && pwd)"
  [[ "$(git -C "$DEST" rev-parse --show-toplevel 2>/dev/null)" == "$DEST" ]] \
    || { echo "error: $DEST is not the root of a git repo" >&2; exit 1; }
  [[ -z "$(git -C "$DEST" status --porcelain)" ]] \
    || { echo "error: $DEST has uncommitted changes" >&2; exit 1; }
  EXTRA="$(git -C "$DEST" ls-files | grep -v '^LICENSE$' || true)"
  [[ -z "$EXTRA" ]] || { echo "error: $DEST already has files besides LICENSE:" >&2; echo "$EXTRA" >&2; exit 1; }
  ORIGIN="$(git -C "$DEST" remote get-url origin 2>/dev/null || true)"
  case "$ORIGIN" in
    */"$FULL"|*/"$FULL".git) ;;
    *) echo "error: origin of $DEST is '$ORIGIN', expected $FULL" >&2; exit 1 ;;
  esac
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
  done < <(grep -rlI --null --exclude-dir=.git -e '__[A-Z_]*__' . || true)

  while IFS= read -r -d '' path; do
    base="$(basename "$path")"
    new="${base//__MODULE__/$MODULE}"
    [[ "$new" != "$base" ]] && mv "$path" "$(dirname "$path")/$new"
  done < <(find . -depth -name '*__MODULE__*' -not -path './.git/*' -print0)

  # Fail loudly if a token survived.
  if grep -rnI --exclude-dir=.git -e '__MODULE' -e '__REPO__' -e '__OWNER__' -e '__YEAR__' -e '__HOLDER__' \
       -e '__DESCRIPTION__' . ; then
    echo "error: tokens left (see above)" >&2
    exit 1
  fi
)

# 4. Git.
if [[ -n "$INTO_DIR" ]]; then
  git -C "$DEST" add -A
  mark_active
  log "scaffolded into $DEST and staged (nothing committed or pushed)"
  cat <<EOF

Next:
  cd $DEST
  git status && git diff --cached --stat
  make lint && make test            # optional check before the first push
  git commit -m "chore: scaffold $NAME from ios-platform@$PLATFORM_SHA"
  git push
Then, in the ios-platform clone: commit registry/repos.yml (the repo is now active).
Optional repo settings (or use the GitHub UI): squash-only merges, delete branch on merge,
Discussions on, topics.
EOF
  exit 0
fi
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

# 6. Registry.
mark_active
log "done: https://github.com/$FULL  (registry updated; commit platform)"
