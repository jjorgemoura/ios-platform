# git-account.sh — sourced by the scripts in platform/scripts. Needs $ROOT (the platform folder).
#
# This machine may hold more than one GitHub account. The repos these scripts create or clone
# must commit and push as the account that owns this project, whatever the global git config
# says:
#   - commits use user.name and user.email from the ios-platform clone (its local config);
#   - pushes use the account gh is logged in with, not another credential stored for github.com.

PLATFORM_GIT_NAME="$(git -C "$ROOT" config user.name || true)"
PLATFORM_GIT_EMAIL="$(git -C "$ROOT" config user.email || true)"
[[ -n "$PLATFORM_GIT_NAME" && -n "$PLATFORM_GIT_EMAIL" ]] || {
  echo "error: set user.name and user.email in the ios-platform clone (git config --local)" >&2
  exit 1
}

# Commit as the project identity in the repo at $1.
use_platform_identity() {
  git -C "$1" config user.name "$PLATFORM_GIT_NAME"
  git -C "$1" config user.email "$PLATFORM_GIT_EMAIL"
}

# Push with gh's account in the repo at $1. The empty value drops every helper configured
# earlier (system or global, such as osxkeychain), so gh's token is the only one offered.
use_gh_credentials() {
  git -C "$1" config credential.helper ""
  git -C "$1" config --add credential.helper "!gh auth git-credential"
}
