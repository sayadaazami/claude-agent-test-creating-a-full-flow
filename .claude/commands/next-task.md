---
description: PM picks and dispatches the next 1-3 tasks (parallel where possible)
argument-hint: (no args)
---

You are running PM-driven task dispatch.

Invoke the `pm` subagent with this directive:

> Read `docs/tasks.md` and `docs/PHASES.md`. Identify the current phase. Pick 1 to 3 tasks from Todo (or move from Backlog) that can be worked in parallel without dependency conflicts. For each chosen task:
> 1. Move to Doing in tasks.md with `started: <today>`
> 2. Determine which subagent should do it (based on `owner:` field)
>
> Then **invoke up to 3 subagents in parallel** (single message, multiple Agent tool calls), giving each its task spec.
>
> Wait for all to return. After they return:
> - For tasks now in Review: invoke the `code-reviewer` subagent
> - Update today's `docs/daily-reports/` with what happened
> - Run `bash scripts/update-status.sh`

After PM returns, summarize for the user:
- Tasks dispatched + their current status
- Any tasks blocked or needing input
- Phase progress %
