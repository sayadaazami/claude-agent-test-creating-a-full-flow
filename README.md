# Apollo-like

A web app that lets users **search global company and people data**, filter by rich criteria, save lists, and export CSVs. Inspirations: apollo.io, lusha.com, cognism.com.

This repo is built end-to-end by an **AI agent team** (10 specialized subagents) coordinated through Claude Code.

## Quick start (humans)

```bash
# Install dependencies (once you've added the Next.js app in phase 3)
pnpm install

# Run dev server
pnpm dev

# Run tests / build / typecheck
pnpm test
pnpm typecheck
pnpm build

# Refresh the project status board
pnpm status
```

## How the agent team works

Open this repo in Claude Code. The team is defined as 10 subagents in [.claude/agents/](.claude/agents/):

| Agent | Role |
|-------|------|
| `pm` | Project Manager (orchestrator) |
| `po` | Product Owner |
| `ux-designer` | UX/UI Designer |
| `backend-dev-1` | Backend: search APIs |
| `backend-dev-2` | Backend: auth, lists, exports |
| `frontend-dev-1` | Frontend: pages, layouts |
| `frontend-dev-2` | Frontend: components |
| `qa` | QA Engineer |
| `devops` | DevOps |
| `code-reviewer` | Code & Design Reviewer (merge gate) |

### Slash commands

Defined in [.claude/commands/](.claude/commands/):

| Command | What it does |
|---------|--------------|
| `/phase` | Show current phase and progress |
| `/board` | Show the task board (compact) |
| `/standup` | PM generates today's standup report |
| `/assign <agent>` | Assign next backlog task to a specific agent |
| `/next-task` | PM picks 1–3 tasks and dispatches in parallel |
| `/review` | Run code-reviewer on Review-column tasks |
| `/demo <phase>` | Build and document the phase demo |

### Typical day

```text
/phase                    # see where we are
/next-task                # PM dispatches work in parallel
/review                   # code-reviewer reviews ready tasks
/standup                  # end-of-day report
```

When all phase tasks are Done with `qa: ✓`, DevOps tags the release (`v0.<phase>.0`) and a demo file appears under [docs/demos/](docs/demos/).

## Project state

- **Phase:** see [docs/STATUS.md](docs/STATUS.md)
- **Backlog & assignments:** [docs/tasks.md](docs/tasks.md)
- **Phases & acceptance:** [docs/PHASES.md](docs/PHASES.md)
- **Architecture:** [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **Product brief:** [docs/PROJECT.md](docs/PROJECT.md)

## Tech stack

Next.js 15 (App Router) · React 19 · TypeScript strict · Tailwind + shadcn/ui · Prisma + PostgreSQL · Auth.js v5 · Vitest + Playwright · Biome · Turborepo · pnpm

## Quality gates

- TypeScript strict, zero `any`
- Test coverage ≥ 70% lines for app code
- e2e suite at 100% green for every release tag
- Zero serious/critical a11y violations
- Lighthouse ≥ 90 on perf/a11y/best-practices for key pages
- Every code change reviewed by `code-reviewer` before QA

## Limitations of the agent system

This is a **semi-autonomous** framework, not a fully autonomous AI dev team:

- Agents run when invoked (via slash commands or PM orchestration), not 24/7
- A human approves PRs and phase transitions
- Token cost scales with team activity — track with `/standup`
- Up to 3 agents run in parallel per dispatch (cost & coordination)

## Contributing (humans)

If you join in:
1. Read [docs/PROJECT.md](docs/PROJECT.md) and [docs/PHASES.md](docs/PHASES.md)
2. Pick a task from [docs/tasks.md](docs/tasks.md) Backlog/Todo with `owner: <your-role>`
3. Move it to Doing, work on it, follow the same conventions as the agents
4. Submit for review via `/review`

## License

TBD
