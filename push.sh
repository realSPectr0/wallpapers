#!/usr/bin/env bash
# Commit and push any new, changed, or removed wallpapers.
# Skips .originals/ (local backup of raw downloads).
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

git add -A -- . ':!.originals'

if git diff --cached --quiet; then
    echo "Nothing new to push."
    exit 0
fi

added=$(git diff --cached --name-only --diff-filter=A | wc -l)
removed=$(git diff --cached --name-only --diff-filter=D | wc -l)
changed=$(git diff --cached --name-only --diff-filter=MR | wc -l)

msg="Update wallpapers: +${added} added, -${removed} removed, ~${changed} changed"
git commit -q -m "$msg"
echo "$msg"

git push -q origin "$(git branch --show-current)"
echo "Pushed."
