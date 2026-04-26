#!/usr/bin/env bash
# Regenerate docs/STATUS.md from docs/tasks.md.
# Counts tasks per status × phase × owner and rewrites the auto-generated sections.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TASKS="$ROOT/docs/tasks.md"
STATUS="$ROOT/docs/STATUS.md"

if [[ ! -f "$TASKS" ]]; then
  echo "tasks.md not found at $TASKS" >&2
  exit 1
fi

today="$(date +%Y-%m-%d)"

awk -v today="$today" '
BEGIN {
  section = ""
  for (i = 1; i <= 8; i++) { phase_total[i] = 0; phase_done[i] = 0 }
  total = 0; done_c = 0; doing = 0; review = 0; todo = 0; backlog = 0
}
/^## Backlog/ { section = "Backlog"; next }
/^## Todo/    { section = "Todo"; next }
/^## Doing/   { section = "Doing"; next }
/^## Review/  { section = "Review"; next }
/^## Done/    { section = "Done"; next }
/^## /        { section = ""; next }

# Task lines: - [ ] [TASK-XXX] ... phase: N ... owner: X
/^- \[/ {
  if (section == "") next
  total++
  if (section == "Done")    done_c++
  if (section == "Doing")   doing++
  if (section == "Review")  review++
  if (section == "Todo")    todo++
  if (section == "Backlog") backlog++

  line = $0

  # extract phase via match + substr (POSIX awk)
  if (match(line, /phase: [0-9]+/) > 0) {
    chunk = substr(line, RSTART, RLENGTH)
    p = substr(chunk, 8) + 0
    if (p >= 1 && p <= 8) {
      phase_total[p]++
      if (section == "Done") phase_done[p]++
    }
  }

  # extract owner
  if (match(line, /owner: [a-z0-9-]+/) > 0) {
    chunk = substr(line, RSTART, RLENGTH)
    own = substr(chunk, 8)
    owner_count[own]++
  }

  next
}
END {
  printf "TOTAL=%d\n", total
  printf "DONE=%d\n", done_c
  printf "DOING=%d\n", doing
  printf "REVIEW=%d\n", review
  printf "TODO=%d\n", todo
  printf "BACKLOG=%d\n", backlog
  for (i = 1; i <= 8; i++) {
    printf "PHASE_%d_TOTAL=%d\n", i, phase_total[i]
    printf "PHASE_%d_DONE=%d\n", i, phase_done[i]
  }
  for (own in owner_count) {
    printf "OWNER_%s=%d\n", own, owner_count[own]
  }
}
' "$TASKS" > /tmp/apollo-status-vars.$$

# Parse key=value pairs into bash variables / arrays without sourcing (dashes in keys break source)
declare -A OWNERS
declare -A PHASE_TOTAL_MAP
declare -A PHASE_DONE_MAP
TOTAL=0; DONE=0; DOING=0; REVIEW=0; TODO=0; BACKLOG=0
while IFS='=' read -r key val; do
  [[ -z "$key" ]] && continue
  case "$key" in
    TOTAL)   TOTAL="$val" ;;
    DONE)    DONE="$val" ;;
    DOING)   DOING="$val" ;;
    REVIEW)  REVIEW="$val" ;;
    TODO)    TODO="$val" ;;
    BACKLOG) BACKLOG="$val" ;;
    PHASE_*_TOTAL)
      n="${key#PHASE_}"; n="${n%_TOTAL}"
      PHASE_TOTAL_MAP[$n]="$val" ;;
    PHASE_*_DONE)
      n="${key#PHASE_}"; n="${n%_DONE}"
      PHASE_DONE_MAP[$n]="$val" ;;
    OWNER_*)
      OWNERS["${key#OWNER_}"]="$val" ;;
  esac
done < /tmp/apollo-status-vars.$$
rm -f /tmp/apollo-status-vars.$$

# Build progress percent helper
pct() {
  local d="$1" t="$2"
  if [[ "$t" -eq 0 ]]; then echo "0"; else echo "$(( d * 100 / t ))"; fi
}

# Phase names
declare -A PNAME
PNAME[1]="Discovery & Spec"
PNAME[2]="UX/UI Design"
PNAME[3]="Foundation & Architecture"
PNAME[4]="Core Backend APIs"
PNAME[5]="Frontend MVP"
PNAME[6]="Integration"
PNAME[7]="QA & Polish"
PNAME[8]="Deployment & Docs"

# Determine current active phase (first phase with non-zero total and not 100% done)
current_phase=1
for i in 1 2 3 4 5 6 7 8; do
  t="${PHASE_TOTAL_MAP[$i]:-0}"; d="${PHASE_DONE_MAP[$i]:-0}"
  if [[ "$t" -gt 0 && "$d" -lt "$t" ]]; then
    current_phase=$i
    break
  fi
done

# Build phase progress table rows
phase_rows=""
for i in 1 2 3 4 5 6 7 8; do
  t="${PHASE_TOTAL_MAP[$i]:-0}"; d="${PHASE_DONE_MAP[$i]:-0}"
  p="$(pct "$d" "$t")"
  if [[ "$t" -eq 0 ]]; then
    status="pending"
  elif [[ "$d" -eq "$t" ]]; then
    status="done"
  elif [[ "$i" -eq "$current_phase" ]]; then
    status="active"
  else
    status="pending"
  fi
  phase_rows+="| $i | ${PNAME[$i]} | $status | $d/$t | $p% | _pending_ |"$'\n'
done

# Owner pie entries
owner_pie=""
for own in "${!OWNERS[@]}"; do
  owner_pie+="    \"$own\" : ${OWNERS[$own]}"$'\n'
done

overall_pct="$(pct "$DONE" "$TOTAL")"

cat > "$STATUS" <<EOF
# Project Status

**Auto-generated** by \`scripts/update-status.sh\`. Do not edit by hand — your changes will be overwritten.

_Last updated: ${today}_

---

## Phase Progress

| Phase | Name | Status | Tasks | Progress | Tag |
|-------|------|--------|-------|----------|-----|
${phase_rows}
**Overall:** $DONE/$TOTAL tasks Done ($overall_pct%)

---

## Gantt — phase timeline

\`\`\`mermaid
gantt
    title Apollo-like Project Phases
    dateFormat YYYY-MM-DD
    axisFormat %m-%d
    section Discovery
    Phase 1 — Discovery & Spec    :$([[ $current_phase -eq 1 ]] && echo "active, " || echo "")p1, 2026-04-26, 3d
    section Design
    Phase 2 — UX/UI Design        :$([[ $current_phase -eq 2 ]] && echo "active, " || echo "")p2, after p1, 5d
    section Build
    Phase 3 — Foundation          :$([[ $current_phase -eq 3 ]] && echo "active, " || echo "")p3, after p2, 4d
    Phase 4 — Backend APIs        :$([[ $current_phase -eq 4 ]] && echo "active, " || echo "")p4, after p3, 7d
    Phase 5 — Frontend MVP        :$([[ $current_phase -eq 5 ]] && echo "active, " || echo "")p5, after p3, 7d
    section Integrate
    Phase 6 — Integration         :$([[ $current_phase -eq 6 ]] && echo "active, " || echo "")p6, after p4 p5, 4d
    section Ship
    Phase 7 — QA & Polish         :$([[ $current_phase -eq 7 ]] && echo "active, " || echo "")p7, after p6, 4d
    Phase 8 — Deployment & Docs   :$([[ $current_phase -eq 8 ]] && echo "active, " || echo "")p8, after p7, 2d
\`\`\`

> Phases 4 and 5 run **in parallel** after phase 3 completes.

---

## Kanban — task counts

\`\`\`mermaid
pie title Tasks by status
    "Backlog" : $BACKLOG
    "Todo" : $TODO
    "Doing" : $DOING
    "Review" : $REVIEW
    "Done" : $DONE
\`\`\`

---

## Workload — tasks by agent

\`\`\`mermaid
pie title Tasks by owner
${owner_pie}\`\`\`

---

## Current phase

**Phase $current_phase — ${PNAME[$current_phase]}**

See [tasks.md](tasks.md) for the live board, [PHASES.md](PHASES.md) for acceptance criteria.

---

## How to read this file

Tables and Mermaid charts above are regenerated from [tasks.md](tasks.md) on every save. For free-form daily notes, see [daily-reports/](daily-reports/). For per-phase demos, see [demos/](demos/).
EOF

echo "STATUS.md updated: $DONE/$TOTAL tasks ($overall_pct%), current phase $current_phase"
