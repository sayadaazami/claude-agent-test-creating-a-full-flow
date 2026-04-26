# Demo — Phase 0: Agent Team Scaffolding

**Tag:** `v0.0.0`
**Date:** 2026-04-26

## What shipped

The agent team itself — not the product. This phase delivers the operating system that all subsequent phases run on.

- 10 subagents in [.claude/agents/](../../.claude/agents/) covering every role
- 7 slash commands in [.claude/commands/](../../.claude/commands/) for daily operation
- 79 tasks pre-loaded in [tasks.md](../tasks.md) across 8 phases
- Auto-regenerating [STATUS.md](../STATUS.md) with Mermaid Gantt + pie charts
- `code-reviewer` gates every change between dev and QA
- Monorepo skeleton ready for Next.js 15: pnpm workspaces, Turborepo, Biome

## How to run the demo

```bash
# 1) See the project state
cat docs/STATUS.md

# 2) Regenerate STATUS.md on demand
pnpm status

# 3) From within Claude Code, drive the team
/phase            # show current phase + progress
/board            # show full task board
/standup          # PM writes today's standup to docs/daily-reports/
/assign po        # assign next backlog task to the PO agent
/next-task        # PM picks 1-3 tasks and dispatches in parallel
/review           # code-reviewer reviews tasks in Review column
/demo 1           # build the Phase 1 demo (after Phase 1 completes)
```

## What to look at

- [README.md](../../README.md) — entry point for humans
- [docs/PROJECT.md](../PROJECT.md) — product brief
- [docs/PHASES.md](../PHASES.md) — what each of 8 phases must deliver
- [docs/ARCHITECTURE.md](../ARCHITECTURE.md) — tech stack + ER diagram
- [docs/tasks.md](../tasks.md) — full backlog with task spec template

## Known limitations

- No code yet — Phase 3 produces the first runnable Next.js app
- Hooks rely on `bash scripts/update-status.sh`; works on macOS / Linux
- Up to 3 agents run in parallel per `/next-task` dispatch (cost / coordination)
- Human approval still required for phase transitions and PR merges

## Next

Phase 1 — Discovery & Spec. Run `/assign po` to start.
