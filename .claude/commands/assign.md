---
description: Assign the next backlog task to a specific role and start work
argument-hint: <agent-name>  e.g. backend-dev-1, frontend-dev-2, qa, devops
---

You are assigning a task to **$ARGUMENTS**.

Steps:

1. Read `docs/tasks.md`.
2. Find the highest-priority task in the `Todo` column with `owner: $ARGUMENTS`. If none, look in `Backlog` and move the highest-priority one to `Todo`.
3. Move the chosen task to `Doing`, add `started: <today>`.
4. Run `bash scripts/update-status.sh`.
5. **Invoke the `$ARGUMENTS` subagent** with this directive:
   > You have been assigned the task `[TASK-XXX]` (paste the full task spec). Follow your standard workflow. When done, move the task to `Review` with `reviewer: code-reviewer` and append a one-line entry to today's `docs/daily-reports/` file.

After the subagent returns, report to the user:
- Task ID + title
- Status (in Review / blocked / failed)
- Files changed
- Next step
