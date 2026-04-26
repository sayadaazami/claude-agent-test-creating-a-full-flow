#!/usr/bin/env bash
# Commit the staged changes for a task with a structured message.
# Used by dev/devops agents at the end of their workflow (after moving task to Review).
#
# Usage: bash scripts/commit-task.sh TASK-XXX "short description"
#
# It:
# - validates we're inside a git repo
# - validates there are staged or unstaged changes to commit
# - if a GitHub Issue with the same task ID is linked, references it via "Refs #N"
# - signs the commit with the Claude co-author trailer

set -euo pipefail

TASK_ID="${1:-}"
TITLE="${2:-}"

if [[ -z "$TASK_ID" || -z "$TITLE" ]]; then
  echo "usage: bash scripts/commit-task.sh TASK-XXX \"short description\"" >&2
  exit 2
fi

if ! [[ "$TASK_ID" =~ ^TASK-[0-9]+$ ]]; then
  echo "error: TASK_ID must look like TASK-035" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

git rev-parse --is-inside-work-tree >/dev/null

# Stage everything tracked + new
git add -A

# Verify we have something to commit
if git diff --cached --quiet; then
  echo "no staged changes — nothing to commit" >&2
  exit 1
fi

# Try to find a linked issue number from .github/task-issue-map.tsv (created by sync-tasks-to-github.sh)
issue_ref=""
map_file=".github/task-issue-map.tsv"
if [[ -f "$map_file" ]]; then
  num="$(awk -v t="$TASK_ID" '$1==t{print $2}' "$map_file")"
  if [[ -n "$num" ]]; then
    issue_ref=$'\n'"Refs #$num"
  fi
fi

msg="[$TASK_ID] $TITLE"$'\n\n'"Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"$issue_ref

git commit -m "$msg"
echo "committed: $TASK_ID"
