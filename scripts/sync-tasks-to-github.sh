#!/usr/bin/env bash
# One-time migration: read docs/tasks.md and create matching
# GitHub Issues + a Projects v2 board.
#
# Requirements:
# - gh CLI (>= 2.40) installed and authenticated: `gh auth login`
# - Token scopes: repo, project (run: `gh auth refresh -s project`)
# - Run from repo root.
#
# What it creates:
# 1) Labels:
#    - phase-1 ... phase-8           (color per phase)
#    - priority-P0 / P1 / P2         (red/orange/yellow)
#    - owner-pm / po / ux-designer / backend-dev-1 / backend-dev-2 /
#      frontend-dev-1 / frontend-dev-2 / qa / devops    (blue)
#    - type-task                     (gray)
# 2) One Issue per task in docs/tasks.md (idempotent — skips if title exists)
# 3) A Projects v2 board "Apollo-like" with Status column = Backlog/Todo/Doing/Review/Done
# 4) Every issue added to the project, Status set to its current column from tasks.md
# 5) Mapping written to .github/task-issue-map.tsv  (TASK-ID<TAB>issue_number)
#
# Idempotent: re-running won't double-create. Safe to run multiple times.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PROJECT_TITLE="Apollo-like"
TASKS_FILE="docs/tasks.md"
MAP_FILE=".github/task-issue-map.tsv"

mkdir -p .github

# --- Sanity checks ---------------------------------------------------------

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI not installed. Install: https://cli.github.com" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "error: gh not authenticated. Run: gh auth login" >&2
  exit 1
fi

# Check project scope
if ! gh auth status 2>&1 | grep -q "project"; then
  echo "warn: 'project' scope may be missing. If creation fails, run: gh auth refresh -s project,read:project,repo" >&2
fi

REPO_NWO="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
OWNER="${REPO_NWO%/*}"
echo "Repo: $REPO_NWO"

# --- 1) Labels -------------------------------------------------------------

ensure_label() {
  local name="$1" color="$2" desc="$3"
  if gh label list --limit 200 --json name --jq '.[].name' | grep -qx "$name"; then
    return 0
  fi
  gh label create "$name" --color "$color" --description "$desc" >/dev/null
  echo "  + label: $name"
}

echo "Ensuring labels..."
ensure_label "phase-1" "0E8A16" "Phase 1 — Discovery & Spec"
ensure_label "phase-2" "1D76DB" "Phase 2 — UX/UI Design"
ensure_label "phase-3" "5319E7" "Phase 3 — Foundation"
ensure_label "phase-4" "B60205" "Phase 4 — Core Backend APIs"
ensure_label "phase-5" "D93F0B" "Phase 5 — Frontend MVP"
ensure_label "phase-6" "FBCA04" "Phase 6 — Integration"
ensure_label "phase-7" "0052CC" "Phase 7 — QA & Polish"
ensure_label "phase-8" "006B75" "Phase 8 — Deployment & Docs"
ensure_label "priority-P0" "B60205" "Critical — must ship this phase"
ensure_label "priority-P1" "D93F0B" "Important — should ship this phase"
ensure_label "priority-P2" "FBCA04" "Nice-to-have — can slip"
for owner in pm po ux-designer backend-dev-1 backend-dev-2 frontend-dev-1 frontend-dev-2 qa devops code-reviewer; do
  ensure_label "owner-$owner" "0366D6" "Owner: $owner agent"
done
ensure_label "type-task" "C5DEF5" "Standard task"

# --- 2) Issues -------------------------------------------------------------

# Re-init the map so re-running picks up newly-created issues
: > "$MAP_FILE"

current_section=""

# Get all existing issues once (titles only) for fast lookup
existing_titles="$(gh issue list --state all --limit 1000 --json number,title --jq '.[] | "\(.number)\t\(.title)"' || true)"

# Helper: get issue number for a title (exact match), or empty if absent
issue_num_for_title() {
  local title="$1"
  printf '%s\n' "$existing_titles" | awk -F'\t' -v t="$title" '$2==t{print $1; exit}'
}

# Read tasks.md line-by-line
while IFS= read -r line || [[ -n "$line" ]]; do
  # Track section headers
  case "$line" in
    "## Backlog"*) current_section="Backlog"; continue ;;
    "## Todo"*)    current_section="Todo"; continue ;;
    "## Doing"*)   current_section="Doing"; continue ;;
    "## Review"*)  current_section="Review"; continue ;;
    "## Done"*)    current_section="Done"; continue ;;
    "## "*)        current_section=""; continue ;;
  esac

  # Match: - [ ] [TASK-XXX] title — phase: N — owner: X — priority: P? — estimate: ?
  if [[ "$line" =~ ^-\ \[(.{1})\]\ \[(TASK-[0-9]+)\]\ (.+)$ ]]; then
    rest="${BASH_REMATCH[3]}"
    task_id="${BASH_REMATCH[2]}"

    # Title is everything before the first " — "
    title_part="${rest%%' — '*}"
    issue_title="[$task_id] $title_part"

    # Extract metadata from rest of the line (em-dash separated key: val)
    phase=""; owner=""; priority=""; estimate=""
    IFS='—' read -r -a parts <<< "$rest"
    for p in "${parts[@]}"; do
      key="$(echo "$p" | sed -E 's/^ *([a-zA-Z]+):.*/\1/' | tr '[:upper:]' '[:lower:]')"
      val="$(echo "$p" | sed -E 's/^ *[a-zA-Z]+: *//; s/ *$//')"
      case "$key" in
        phase)    phase="$val" ;;
        owner)    owner="$val" ;;
        priority) priority="$val" ;;
        estimate) estimate="$val" ;;
      esac
    done

    # Build labels list
    labels=("type-task")
    [[ -n "$phase" ]]    && labels+=("phase-$phase")
    [[ -n "$owner" ]]    && labels+=("owner-$owner")
    [[ -n "$priority" ]] && labels+=("priority-$priority")

    # Check if issue already exists
    existing="$(issue_num_for_title "$issue_title")"
    if [[ -n "$existing" ]]; then
      echo "  = $task_id already issue #$existing"
      printf '%s\t%s\t%s\n' "$task_id" "$existing" "$current_section" >> "$MAP_FILE"
      continue
    fi

    # Build the issue body
    body=$(cat <<EOF
**Task ID:** \`$task_id\`
**Phase:** $phase
**Owner:** \`$owner\`
**Priority:** $priority
**Estimate:** $estimate
**Status (in tasks.md):** $current_section

---

This issue mirrors a row from [docs/tasks.md](../blob/main/docs/tasks.md).

The board lives in two places:
- the markdown file (the source of truth agents read every cycle)
- this GitHub Project (for human-friendly visualisation)

The \`scripts/sync-tasks-to-github.sh\` script keeps them in sync. When the agent commits a task, the commit body has \`Refs #<this-number>\` so the issue auto-references the work.
EOF
)

    # Comma-join labels
    label_args=()
    for l in "${labels[@]}"; do label_args+=(--label "$l"); done

    issue_url="$(gh issue create --title "$issue_title" --body "$body" "${label_args[@]}")"
    issue_num="${issue_url##*/}"
    echo "  + $task_id → issue #$issue_num [$current_section]"
    printf '%s\t%s\t%s\n' "$task_id" "$issue_num" "$current_section" >> "$MAP_FILE"
  fi
done < "$TASKS_FILE"

echo "Issue map written to $MAP_FILE"

# --- 3) Project v2 ---------------------------------------------------------

echo "Ensuring Project: $PROJECT_TITLE"

# Find existing project by title (user-scope)
project_number="$(gh project list --owner "$OWNER" --format json 2>/dev/null | \
  jq -r --arg t "$PROJECT_TITLE" '.projects[]? | select(.title==$t) | .number' | head -1 || true)"

if [[ -z "$project_number" ]]; then
  echo "  creating project..."
  project_number="$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json | jq -r '.number')"
  echo "  + project #$project_number"
else
  echo "  = project #$project_number exists"
fi

# Get the project id (Node ID, needed for GraphQL operations)
project_id="$(gh project view "$project_number" --owner "$OWNER" --format json | jq -r '.id')"

# Find or create the Status field with required options
echo "  ensuring Status field options..."
status_field_json="$(gh project field-list "$project_number" --owner "$OWNER" --format json)"
status_field_id="$(echo "$status_field_json" | jq -r '.fields[] | select(.name=="Status") | .id')"

if [[ -z "$status_field_id" || "$status_field_id" == "null" ]]; then
  echo "  warn: Status single-select field not found. The default 'Status' field should exist on a fresh project — please add it manually if missing." >&2
fi

# Map our column name → option id
declare -A STATUS_OPT
while IFS=$'\t' read -r oname oid; do
  STATUS_OPT["$oname"]="$oid"
done < <(echo "$status_field_json" | jq -r '.fields[] | select(.name=="Status") | .options[]? | "\(.name)\t\(.id)"')

# We need columns matching: Backlog, Todo, Doing, Review, Done
# GitHub default has: Todo, In Progress, Done. Try to remap; if missing, fall back.
get_opt() {
  local name="$1"
  echo "${STATUS_OPT[$name]:-}"
}

# --- 4) Add issues to project + set status --------------------------------

echo "Adding issues to project + setting Status..."
while IFS=$'\t' read -r task_id issue_num section; do
  [[ -z "$task_id" ]] && continue
  issue_url="https://github.com/$REPO_NWO/issues/$issue_num"

  # Add to project (idempotent — gh handles duplicates)
  item_id="$(gh project item-add "$project_number" --owner "$OWNER" --url "$issue_url" --format json 2>/dev/null | jq -r '.id' || true)"
  if [[ -z "$item_id" || "$item_id" == "null" ]]; then
    # Already in project — find item id
    item_id="$(gh project item-list "$project_number" --owner "$OWNER" --format json | \
      jq -r --arg u "$issue_url" '.items[] | select(.content.url==$u) | .id' | head -1)"
  fi

  if [[ -z "$item_id" || "$item_id" == "null" ]]; then
    echo "  ! could not resolve item for $task_id" >&2
    continue
  fi

  # Map section → option (best-effort)
  case "$section" in
    Backlog|Todo|Doing|Review|Done) target="$section" ;;
    *) target="" ;;
  esac

  if [[ -n "$target" ]]; then
    opt_id="$(get_opt "$target")"
    # Try common aliases if exact match missing
    if [[ -z "$opt_id" && "$target" == "Doing" ]]; then opt_id="$(get_opt "In Progress")"; fi
    if [[ -z "$opt_id" && "$target" == "Review" ]]; then opt_id="$(get_opt "In Review")"; fi
    if [[ -n "$opt_id" && -n "$status_field_id" ]]; then
      gh project item-edit \
        --project-id "$project_id" \
        --id "$item_id" \
        --field-id "$status_field_id" \
        --single-select-option-id "$opt_id" >/dev/null || true
    fi
  fi
  echo "  · $task_id → #$issue_num ($section)"
done < "$MAP_FILE"

echo
echo "Done."
echo "  Repo:    https://github.com/$REPO_NWO"
echo "  Issues:  https://github.com/$REPO_NWO/issues"
echo "  Project: https://github.com/users/$OWNER/projects/$project_number"
