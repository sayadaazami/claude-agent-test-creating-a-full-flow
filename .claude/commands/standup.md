---
description: Generate today's standup report by invoking the PM agent
argument-hint: (no args)
---

You are running the **daily standup** for the Apollo-like project.

Invoke the `pm` subagent with the following directive:

> Run a standup. Read `docs/tasks.md` and the last 3 entries in `docs/daily-reports/`. Produce today's report at `docs/daily-reports/$(date +%Y-%m-%d).md` following the template in your instructions. Identify blockers, propose the next 1–3 tasks to assign, and call them out. After writing the report, run `bash scripts/update-status.sh` to refresh STATUS.md.

After the PM agent returns, summarize for the user:
- Current phase + progress
- Top 3 next tasks
- Any blockers
