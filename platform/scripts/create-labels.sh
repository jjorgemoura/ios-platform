#!/usr/bin/env bash
#
# create-labels.sh — create or update the GitHub labels the agent skills use, in every repo.
#
# Usage:
#   create-labels.sh [--dry-run] [repo ...]
#
# Repos: every repo in registry/repos.yml with status: active (synced or not), plus this repo
# (ios-platform). Name repos to limit it. Safe to re-run: existing labels are updated in place.
#
#   --dry-run   Print what would be created, change nothing.
#
# Labels:
#   triage roles (docs/agents/triage-labels.md): needs-triage, needs-info, ready-for-agent,
#     ready-for-human, wontfix
#   categories used by /triage: bug, enhancement
#   /wayfinder: wayfinder:map, wayfinder:research, wayfinder:prototype, wayfinder:grilling,
#     wayfinder:task
#
# Requirements: bash 3.2+, awk, gh (authenticated).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT/registry/repos.yml"

# name|colour|description
LABELS=(
  "needs-triage|fbca04|Maintainer needs to evaluate this issue"
  "needs-info|d876e3|Waiting on reporter for more information"
  "ready-for-agent|0e8a16|Fully specified, ready for an AFK agent"
  "ready-for-human|1d76db|Requires human implementation"
  "wontfix|ffffff|This will not be worked on"
  "bug|d73a4a|Something isn't working"
  "enhancement|a2eeef|New feature or request"
  "wayfinder:map|5319e7|Wayfinder map: index of decision tickets"
  "wayfinder:research|c5def5|Wayfinder ticket: research"
  "wayfinder:prototype|c5def5|Wayfinder ticket: prototype"
  "wayfinder:grilling|c5def5|Wayfinder ticket: grilling"
  "wayfinder:task|c5def5|Wayfinder ticket: task"
)

DRY_RUN=false
ONLY=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *)         ONLY+=("$1") ;;
  esac
  shift
done

command -v gh >/dev/null || { echo "error: gh is required" >&2; exit 1; }

OWNER="$(sed -n 's/^owner: *//p' "$REGISTRY" | head -n 1)"

REPOS=()
if [[ ${#ONLY[@]} -gt 0 ]]; then
  REPOS=("${ONLY[@]}")
else
  while IFS= read -r line; do REPOS+=("$line"); done < <(awk '
    function flush() { if (name != "" && status == "active") print name }
    /^  - name:/ { flush(); name = $3; status = ""; next }
    /^    status:/ { status = $2; next }
    END { flush() }
  ' "$REGISTRY")
  REPOS+=("ios-platform")
fi

FAILED=()
for repo in "${REPOS[@]}"; do
  for entry in "${LABELS[@]}"; do
    IFS='|' read -r name colour description <<< "$entry"
    if $DRY_RUN; then
      printf '[%s] would create or update %s\n' "$repo" "$name"
    elif gh label create "$name" --repo "$OWNER/$repo" --color "$colour" \
           --description "$description" --force >/dev/null; then
      printf '[%s] %s\n' "$repo" "$name"
    else
      printf '[%s] FAILED %s\n' "$repo" "$name" >&2
      FAILED+=("$repo:$name")
    fi
  done
done

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "Failed: ${FAILED[*]}" >&2
  exit 1
fi
