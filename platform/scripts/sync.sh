#!/usr/bin/env bash
#
# sync.sh — copy the shared files in platform/templates/sync into library repos.
#
# Usage:
#   sync.sh --local-dir DIR        Apply to a local checkout. Nothing is committed or pushed:
#                                  review the result with `git diff` in DIR. Needs no gh.
#   sync.sh [--dry-run] [repo ...] Clone each repo, apply, and open (or update) one pull
#                                  request per repo. Repos come from registry/repos.yml:
#                                  status: active and sync: true. Name repos to limit it.
#
#   --dry-run   Clone and show what would change, but do not commit, push or open PRs.
#
# How files map:
#   templates/sync/<path>       -> <repo>/<path>   (whole file, overwritten)
#   templates/sync/AGENTS.md    -> the block between the BEGIN/END platform markers inside
#                                  <repo>/AGENTS.md; the library part below it is kept.
#
# Known gaps (TODO):
#   - Files deleted from templates/sync are not deleted in the repos.
#   - Per-repo exclusions are not supported.
#
# Requirements: bash 3.2+, git, awk. For the PR mode also gh (authenticated).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES="$ROOT/templates/sync"
REGISTRY="$ROOT/registry/repos.yml"

BRANCH="platform-sync"
BEGIN_MARK="<!-- BEGIN platform (synced, do not edit) -->"
END_MARK="<!-- END platform -->"

DRY_RUN=false
LOCAL_DIR=""
ONLY=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=true ;;
    --local-dir) LOCAL_DIR="${2:?--local-dir needs a directory}"; shift ;;
    -h|--help)   sed -n '2,24p' "$0"; exit 0 ;;
    *)           ONLY+=("$1") ;;
  esac
  shift
done

PLATFORM_SHA="$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"

log() { printf '[%s] %s\n' "$1" "$2"; }

# Replace (or insert) the managed block in $2 with the contents of $1.
sync_managed_block() {
  local src="$1" dest="$2" tmp
  tmp="$(mktemp)"

  if [[ -f "$dest" ]] && grep -qF "$BEGIN_MARK" "$dest"; then
    awk -v begin="$BEGIN_MARK" -v end="$END_MARK" -v src="$src" '
      index($0, begin) == 1 { print; while ((getline line < src) > 0) print line; skip = 1; next }
      index($0, end)   == 1 { skip = 0 }
      !skip { print }
    ' "$dest" > "$tmp"
  else
    # No markers yet: put the managed block at the top, keep any existing content below.
    { echo "$BEGIN_MARK"; cat "$src"; echo "$END_MARK"; echo
      [[ -f "$dest" ]] && cat "$dest"; } > "$tmp"
  fi

  cat "$tmp" > "$dest"
  rm -f "$tmp"
}

# Copy every template file into the repo checkout at $1.
apply_templates() {
  local repo_dir="$1" file rel
  while IFS= read -r -d '' file; do
    rel="${file#"$TEMPLATES"/}"
    mkdir -p "$repo_dir/$(dirname "$rel")"
    if [[ "$rel" == "AGENTS.md" ]]; then
      sync_managed_block "$file" "$repo_dir/$rel"
    else
      cp "$file" "$repo_dir/$rel"
    fi
  done < <(find "$TEMPLATES" -type f ! -name .DS_Store -print0)
}

# Names of repos to sync: status active and sync true.
registry_repos() {
  awk '
    function flush() { if (name != "" && status == "active" && sync == "true") print name }
    /^  - name:/ { flush(); name = $3; status = ""; sync = ""; next }
    /^    status:/ { status = $2; next }
    /^    sync:/ { sync = $2; next }
    END { flush() }
  ' "$REGISTRY"
}

sync_repo_in() {
  local name="$1" full="$2" dir="$3"

  log "$name" "cloning $full"
  gh repo clone "$full" "$dir" -- --quiet --depth 1
  git -C "$dir" checkout --quiet -B "$BRANCH"

  apply_templates "$dir"

  if [[ -z "$(git -C "$dir" status --porcelain)" ]]; then
    log "$name" "up to date"
    return 0
  fi

  log "$name" "changes:"
  git -C "$dir" status --short | sed 's/^/    /'

  if $DRY_RUN; then
    git -C "$dir" --no-pager diff --stat
    return 0
  fi

  git -C "$dir" add -A
  git -C "$dir" commit --quiet -m "chore: sync platform templates (ios-platform@$PLATFORM_SHA)"
  # Force-push: the sync branch is always regenerated from main + templates.
  git -C "$dir" push --quiet --force origin "$BRANCH"

  local pr
  pr="$(gh pr list --repo "$full" --head "$BRANCH" --state open --json number -q '.[0].number')"
  if [[ -n "$pr" ]]; then
    gh pr comment "$pr" --repo "$full" --body "Updated to ios-platform@$PLATFORM_SHA."
    log "$name" "updated PR #$pr"
  else
    gh pr create --repo "$full" --head "$BRANCH" --base main \
      --title "chore: sync platform templates" \
      --body "Automated sync of shared files from \`platform/templates/sync\` at ios-platform@$PLATFORM_SHA.

Review the diff. The managed block in \`AGENTS.md\` is replaced; the rest of that file is untouched."
    log "$name" "opened PR"
  fi
}

sync_repo() {
  local name="$1" dir rc=0
  dir="$(mktemp -d)"
  sync_repo_in "$name" "$OWNER/$name" "$dir" || rc=$?
  rm -rf "$dir"
  return $rc
}

# --- local mode ------------------------------------------------------------

if [[ -n "$LOCAL_DIR" ]]; then
  [[ -d "$LOCAL_DIR" ]] || { echo "error: $LOCAL_DIR is not a directory" >&2; exit 1; }
  apply_templates "$LOCAL_DIR"
  log "$(basename "$LOCAL_DIR")" "applied. Review with: git -C \"$LOCAL_DIR\" diff"
  exit 0
fi

# --- PR mode ---------------------------------------------------------------

for tool in git gh; do
  command -v "$tool" >/dev/null || { echo "error: $tool is required" >&2; exit 1; }
done

OWNER="$(sed -n 's/^owner: *//p' "$REGISTRY" | head -n 1)"

REPOS=()
if [[ ${#ONLY[@]} -gt 0 ]]; then
  REPOS=("${ONLY[@]}")
else
  while IFS= read -r line; do REPOS+=("$line"); done < <(registry_repos)
fi

if [[ ${#REPOS[@]} -eq 0 ]]; then
  echo "No repos to sync (need status: active and sync: true in $REGISTRY)." >&2
  exit 0
fi

FAILED=()
for repo in "${REPOS[@]}"; do
  if ! sync_repo "$repo"; then
    log "$repo" "FAILED"
    FAILED+=("$repo")
  fi
done

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "Failed: ${FAILED[*]}" >&2
  exit 1
fi
