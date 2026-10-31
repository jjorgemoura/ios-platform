#!/usr/bin/env bash
#
# create-library.sh — create a new library repo from swift-library-template.
#
# Usage:
#   scripts/create-library.sh <repo-name> <ModuleName> ["Description"]
#   scripts/create-library.sh gpx-swift GPXSwift "Read, write, clean and enrich GPX files"
#
# Steps:
#   1. gh repo create --template  (GitHub copies the template's files; nothing else)
#   2. clone, run scripts/bootstrap.sh, commit, push
#   3. repo settings: squash-only merges, delete merged branches, topics
#   4. branch protection on main (GIT-1, GIT-2)
#   5. mark the repo active in registry/repos.yml
#
# Requirements: gh (authenticated), git, yq, perl.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT/registry/repos.yml"
TEMPLATE_REPO="swift-library-template"

if [[ $# -lt 2 ]]; then sed -n '2,17p' "$0"; exit 1; fi

NAME="$1"
MODULE="$2"
DESCRIPTION="${3:-}"
OWNER="$(yq -r '.owner' "$REGISTRY")"
FULL="$OWNER/$NAME"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

log() { printf '[%s] %s\n' "$NAME" "$1"; }

if gh repo view "$FULL" >/dev/null 2>&1; then
  echo "error: $FULL already exists" >&2
  exit 1
fi

# 1. Create from template. Public: libraries are open source (ADR-0001).
log "creating $FULL from $OWNER/$TEMPLATE_REPO"
gh repo create "$FULL" --public --template "$OWNER/$TEMPLATE_REPO" --description "$DESCRIPTION"

# GitHub copies template files asynchronously; wait for main to exist.
for _ in $(seq 1 30); do
  gh api "repos/$FULL/branches/main" >/dev/null 2>&1 && break
  sleep 2
done
gh api "repos/$FULL/branches/main" >/dev/null || { echo "error: main never appeared" >&2; exit 1; }

# 2. Bootstrap placeholders.
log "bootstrapping"
gh repo clone "$FULL" "$WORK/$NAME" -- --quiet
(
  cd "$WORK/$NAME"
  bash scripts/bootstrap.sh "$NAME" "$MODULE" "$OWNER"
  git add -A
  git commit --quiet -m "chore: bootstrap $NAME from $TEMPLATE_REPO"
  git push --quiet origin main
)

# 3. Repo settings.
log "applying settings"
gh repo edit "$FULL" \
  --enable-squash-merge \
  --enable-merge-commit=false \
  --enable-rebase-merge=false \
  --delete-branch-on-merge \
  --enable-wiki=false \
  --add-topic swift --add-topic swift-package --add-topic ios --add-topic macos

# 4. Branch protection. Required checks are added once the reusable CI exists.
# TODO: set required_status_checks.contexts to the CI job names (CI-3).
log "protecting main"
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

# 5. Registry.
NAME="$NAME" yq -i '(.repos[] | select(.name == env(NAME)) | .status) = "active"' "$REGISTRY"
log "done: https://github.com/$FULL  (registry updated; commit platform)"
