---
description: Generate or run a phase demo
argument-hint: <phase-number>  e.g. 3
---

You are preparing the demo for **phase $ARGUMENTS**.

Steps:

1. Verify all tasks in `docs/tasks.md` for `phase: $ARGUMENTS` are `Done` and have `qa: ✓`.
2. If not all done, report what's missing and stop.
3. If all done:
   - Read `docs/PHASES.md` to recall the phase's stated outcomes
   - Check the git tag `v0.$ARGUMENTS.0` exists; if not, ask the `devops` subagent to create it (standard release workflow)
   - Generate or update `docs/demos/phase-$ARGUMENTS.md` with:
     - Title + tag
     - Summary of what shipped
     - **How to run** the demo locally: exact commands
     - **What to look at**: links to the routes, sample queries
     - **Screenshots/Mermaid** of key flows
     - **Known limitations** for this phase
4. Run `bash scripts/update-status.sh`.

Then output for the user:
- Path to the demo file
- The "how to run" block as a fenced code section so they can copy-paste
