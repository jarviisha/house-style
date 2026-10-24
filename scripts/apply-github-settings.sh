#!/usr/bin/env bash
# Apply house-style merge settings to GitHub repos.
# Usage: apply-github-settings.sh [--dry-run] [owner/repo ...]
# With no repos, reads repos.txt next to this script's parent dir.
# Safe to re-run: repos already in shape are left alone.
set -euo pipefail

dry_run=false
if [[ ${1:-} == --dry-run ]]; then dry_run=true; shift; fi

if (($# == 0)); then
  mapfile -t repos < <(grep -v '^\s*\(#\|$\)' "$(dirname "$0")/../repos.txt")
else
  repos=("$@")
fi

target='{"allow_squash_merge":true,"allow_merge_commit":false,"allow_rebase_merge":false,"squash_merge_commit_title":"PR_TITLE","squash_merge_commit_message":"PR_BODY","delete_branch_on_merge":true}'

for repo in "${repos[@]}"; do
  current=$(gh api "repos/$repo" | jq -c --argjson t "$target" 'with_entries(select(.key as $k | $t | has($k)))')
  diff=$(jq -rn --argjson c "$current" --argjson t "$target" \
    '$t | to_entries[] | select($c[.key] != .value) | "  \(.key): \($c[.key]) -> \(.value)"')
  if [[ -z $diff ]]; then
    echo "$repo: ok"
    continue
  fi
  echo "$repo:"
  echo "$diff"
  if ! $dry_run; then
    gh api -X PATCH "repos/$repo" --input - <<<"$target" >/dev/null
    echo "  applied"
  fi
done
