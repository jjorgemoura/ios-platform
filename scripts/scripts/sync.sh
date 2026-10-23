#!/usr/bin/env bash
#
# sync.sh — push files from templates/ into every library repo listed in
# registry/repos.yml, opening (or updating) one pull request per repo.
#
# Usage:
#   scripts/sync.sh [--dry-run] [repo ...]
#
#   --dry-run   Clone and diff, but do not commit, push or open PRs.
#   repo ...    Only sync these repos (names as in repos.yml). Default: all with sync: true.
#
# Requirements: bash, git, gh (authenticated), yq (mikefarah/yq v4).
# In CI, GH_TOKEN must be a token with contents + pull-requests write access
# to the target repos (the default GITHUB_TOKEN cannot push to other repos).
#
# How files map:
#   templates/<path>            -> <repo>/<path>          (whole file, overwritten)
#   templates/AGENTS.md         -> managed block inside <repo>/AGENTS.md
#                                  between the BEGIN/END platform markers;
#                                  the library-specific part below is kept.
#
# Known gaps (TODO):
#   - Files deleted from templates/ are not deleted in the repos.
#   - Per-repo exclusions (e.g. audio-swift skipping a file) are not supported yet.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES="$ROOT/templates"
REGISTRY="$ROOT/registry/repos.yml"

BRANCH="platform-sync"
MANAGED_FILES=("AGENTS.md")           # files synced as a managed block, not whole
BEGIN_MARK="<!-- BEGIN platform (synced, do not edit) -->"
END_MARK="<!-- END platform -->"

DRY_RUN=false
ONLY=()

# --- arguments -------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    -h|--help) sed -n '2,25p' "$0"; exit 0 ;;
    *) ONLY+=("$1") ;;
  esac
  shift
done

for tool in git gh yq; do
  command -v "$tool" >/dev/null || { echo "error: $tool is required" >&2; exit 1; }
done

OWNER="$(yq -r '.owner' "$REGISTRY")"
PLATFORM_SHA="$(git -C "$ROOT" rev-parse --short HEAD)"

log() { printf '[%s] %s\n' "$1" "$2"; }

is_managed() {
  local f="$1"
  for m in "${MANAGED_FILES[@]}"; do [[ "$f" == "$m" ]] && return 0; done
  return 1
}

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

  mv "$tmp" "$dest"
}

# Copy every template file into the repo checkout at $1.
apply_templates() {
  local repo_dir="$1" rel
  while IFS= read -r -d '' file; do
    rel="${file#"$TEMPLATES"/}"
    mkdir -p "$repo_dir/$(dirname "$rel")"
    if is_managed "$rel"; then
      sync_managed_block "$file" "$repo_dir/$rel"
    else
      cp "$file" "$repo_dir/$rel"
    fi
  done < <(find "$TEMPLATES" -type f -print0)
}

sync_repo() {
  local name="$1" full="$OWNER/$1" dir
  dir="$(mktemp -d)"
  trap 'rm -rf "$dir"' RETURN

  log "$name" "cloning $full"
  gh repo clone "$full" "$dir" -- --quiet --depth 1
  git -C "$dir" checkout --quiet -B "$BRANCH"

  apply_templates "$dir"

  if [[ -z "$(git -C "$dir" status --porcelain)" ]]; then
    log "$name" "up to date"
    return
  fi

  log "$name" "changes:"
  git -C "$dir" status --short | sed 's/^/    /'

  if $DRY_RUN; then
    git -C "$dir" --no-pager diff --stat
    return
  fi

  git -C "$dir" add -A
  git -C "$dir" commit --quiet -m "chore: sync platform templates (platform@$PLATFORM_SHA)"
  # Force-push: the sync branch is always regenerated from main + templates.
  git -C "$dir" push --quiet --force origin "$BRANCH"

  local pr
  pr="$(gh pr list --repo "$full" --head "$BRANCH" --state open --json number -q '.[0].number')"
  if [[ -n "$pr" ]]; then
    gh pr comment "$pr" --repo "$full" --body "Updated to platform@$PLATFORM_SHA."
    log "$name" "updated PR #$pr"
  else
    gh pr create --repo "$full" --head "$BRANCH" --base main \
      --title "chore: sync platform templates" \
      --body "Automated sync of shared files from \`platform/templates\` at platform@$PLATFORM_SHA.

Review the diff; the managed block in \`AGENTS.md\` is replaced, the rest of that file is untouched."
    log "$name" "opened PR"
  fi
}

# --- main ------------------------------------------------------------------

mapfile -t REPOS < <(yq -r '.repos[] | select(.sync == true) | .name' "$REGISTRY")

if [[ ${#ONLY[@]} -gt 0 ]]; then
  REPOS=("${ONLY[@]}")
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
