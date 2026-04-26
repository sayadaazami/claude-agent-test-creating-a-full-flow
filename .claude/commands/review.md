---
description: Run the code-reviewer on all tasks currently in Review (reviewer:code-reviewer)
argument-hint: (optional task ID, e.g. TASK-035)
---

You are dispatching code review.

Steps:

1. Read `docs/tasks.md`.
2. If `$ARGUMENTS` is a task ID: review only that task. Otherwise: gather all tasks in `Review` with `reviewer: code-reviewer`.
3. For each task (max 3 per run to keep the diff manageable):
   - **Invoke the `code-reviewer` subagent** with the task ID and the diff scope (`git diff --name-only` since the task started, or last commit if no marker).
4. After reviewer returns, update `tasks.md`:
   - On `approve`: change `reviewer: qa`
   - On `request-changes`/`block`: change owner back to original dev, increment `revision: N`
5. Run `bash scripts/update-status.sh`.

Output to user: list of tasks reviewed and verdicts.
