# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `scripts/commit-task.sh` — dev/devops agents now auto-commit per task with `Refs #N` linkage to GitHub Issues
- `scripts/sync-tasks-to-github.sh` — one-time migration of `docs/tasks.md` → GitHub Issues + Projects v2 board, idempotent re-syncing
- `.github/task-issue-map.tsv` (generated) — maps TASK-IDs to issue numbers
- README section on GitHub board sync workflow
- Auto-commit step added to: backend-dev-1, backend-dev-2, frontend-dev-1, frontend-dev-2, devops, qa

## [v0.0.0] — 2026-04-26 — Phase 0: Agent Team Scaffolding

### Added
- 10 subagents in `.claude/agents/`: pm, po, ux-designer, backend-dev-1, backend-dev-2, frontend-dev-1, frontend-dev-2, qa, devops, code-reviewer
- 7 slash commands in `.claude/commands/`: `/phase`, `/board`, `/standup`, `/assign`, `/next-task`, `/review`, `/demo`
- Project docs: `PROJECT.md`, `PHASES.md`, `ARCHITECTURE.md`
- Task board with 79 pre-loaded tasks across 8 phases (`docs/tasks.md`)
- Auto-generated `STATUS.md` with Mermaid Gantt and pie charts
- Hook-driven status regeneration via `scripts/update-status.sh`
- `code-reviewer` agent acts as merge gate before QA
- Monorepo skeleton: pnpm workspaces, Turborepo, Biome
- First daily report and Phase-0 demo

## [v0.1.0] — _pending_
First product milestone — Phase 1: Discovery & Spec.
