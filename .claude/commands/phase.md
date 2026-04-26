---
description: Show current phase status, progress, and what's left
argument-hint: (no args, or specific phase number)
---

Show project phase status.

Steps:

1. Read `docs/PHASES.md` and `docs/tasks.md`.
2. If `$ARGUMENTS` is empty: identify the *current* phase (the one with the most non-Done tasks).
3. Otherwise: report on the phase number `$ARGUMENTS`.
4. Compute:
   - Total tasks for the phase
   - Done count, Doing count, Todo count, Backlog count
   - Progress percent
   - List Doing tasks with owner + started date
   - List Todo tasks (top 3 by priority)
   - Any task in Review with reviewer + revision count
5. Run `bash scripts/update-status.sh` to ensure STATUS.md reflects the latest.

Output a compact report:

```
Phase <N>: <name>  —  <done>/<total> (<pct>%)
Doing:   <list>
Todo:    <top-3>
Review:  <list with reviewer>
Blocked: <if any>
```

Also link to [STATUS.md](docs/STATUS.md) at the end.
