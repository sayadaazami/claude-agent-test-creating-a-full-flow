# Task Board

This is the **single source of truth** for who does what. Agents read this file to pick their next task. PM reorders and refines.

> **GitHub mirror:** these tasks are also mirrored as Issues + a Projects v2 board.
> Run `bash scripts/sync-tasks-to-github.sh` to migrate / re-sync. The mapping
> lives in `.github/task-issue-map.tsv`. Commits that mention `Refs #N` link
> back to the corresponding issue.

**Columns:** Backlog → Todo → Doing → Review → Done

**Task fields:**
- `[TASK-XXX]` ID, title
- `phase: <N>` — which phase
- `owner: <agent-name>` — who works on it
- `priority: P0|P1|P2`
- `estimate: S|M|L`
- `started: YYYY-MM-DD` (when moved to Doing)
- `reviewer: code-reviewer|qa` (when in Review)
- `revision: N` (review round, increments on rejection)
- `qa: ✓ <date>` (when QA passes)
- `tag: v0.X.0` (when shipped)

---

## Backlog

### Phase 1 — Discovery & Spec
- [ ] [TASK-001] Finalize PROJECT.md decisions section template — phase: 1 — owner: po — priority: P0 — estimate: S
- [ ] [TASK-002] Define MVP feature cut (in/out for v1.0) — phase: 1 — owner: po — priority: P0 — estimate: S
- [ ] [TASK-003] Refine Phase-2 backlog tasks (UX/UI) with full specs — phase: 1 — owner: po — priority: P0 — estimate: M
- [ ] [TASK-004] Refine Phase-3 backlog tasks (foundation) with full specs — phase: 1 — owner: po — priority: P0 — estimate: M
- [ ] [TASK-005] Refine Phase-4 backlog tasks (backend APIs) with full specs — phase: 1 — owner: po — priority: P0 — estimate: M

### Phase 2 — UX/UI Design
- [ ] [TASK-010] Design tokens: color, type, spacing, radii, shadows — phase: 2 — owner: ux-designer — priority: P0 — estimate: M
- [ ] [TASK-011] Wireframe: home (`/`) — phase: 2 — owner: ux-designer — priority: P0 — estimate: S
- [ ] [TASK-012] Wireframe: search (`/search`) with filter panel layout — phase: 2 — owner: ux-designer — priority: P0 — estimate: M
- [ ] [TASK-013] Wireframe: person profile (`/people/[id]`) — phase: 2 — owner: ux-designer — priority: P0 — estimate: S
- [ ] [TASK-014] Wireframe: company profile (`/companies/[id]`) — phase: 2 — owner: ux-designer — priority: P0 — estimate: S
- [ ] [TASK-015] Wireframe: lists index + detail — phase: 2 — owner: ux-designer — priority: P1 — estimate: S
- [ ] [TASK-016] Wireframe: login/signup — phase: 2 — owner: ux-designer — priority: P1 — estimate: S
- [ ] [TASK-017] Component spec: SearchBar — phase: 2 — owner: ux-designer — priority: P0 — estimate: S
- [ ] [TASK-018] Component spec: FilterPanel + FilterMultiSelect + FilterRange — phase: 2 — owner: ux-designer — priority: P0 — estimate: M
- [ ] [TASK-019] Component spec: PersonCard + CompanyCard — phase: 2 — owner: ux-designer — priority: P0 — estimate: S
- [ ] [TASK-020] Component spec: ResultsTable — phase: 2 — owner: ux-designer — priority: P0 — estimate: M
- [ ] [TASK-021] Component spec: SaveToListButton + ExportButton — phase: 2 — owner: ux-designer — priority: P1 — estimate: S
- [ ] [TASK-022] Component spec: EmptyState + LoadingSkeleton + ErrorBoundary — phase: 2 — owner: ux-designer — priority: P1 — estimate: S
- [ ] [TASK-023] User flow: search journey (Mermaid) — phase: 2 — owner: ux-designer — priority: P1 — estimate: S
- [ ] [TASK-024] User flow: auth journey (Mermaid) — phase: 2 — owner: ux-designer — priority: P1 — estimate: S

### Phase 3 — Foundation & Architecture
- [ ] [TASK-030] Initialize pnpm workspaces + Turborepo — phase: 3 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-031] Bootstrap Next.js 15 app under apps/web — phase: 3 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-032] Configure Biome (lint + format) — phase: 3 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-033] Configure Tailwind + shadcn/ui CLI — phase: 3 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-034] Set up Vitest + Playwright — phase: 3 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-035] GitHub Actions: ci.yml (lint, typecheck, test, build) — phase: 3 — owner: devops — priority: P0 — estimate: M
- [ ] [TASK-036] GitHub Actions: e2e.yml (Playwright) — phase: 3 — owner: devops — priority: P1 — estimate: S
- [ ] [TASK-037] Prisma init + schema (User, Person, Company, List, ListItem, ListShare) — phase: 3 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-038] Seed script: 5K companies + 20K people with Faker (referentially consistent) — phase: 3 — owner: backend-dev-1 — priority: P0 — estimate: L
- [ ] [TASK-039] Auth.js v5 scaffold (email + Google) — phase: 3 — owner: backend-dev-2 — priority: P0 — estimate: M
- [ ] [TASK-040] packages/types skeleton (shared Zod schemas) — phase: 3 — owner: backend-dev-1 — priority: P1 — estimate: S
- [ ] [TASK-041] apps/web/lib/cn.ts + lib/prisma.ts singletons — phase: 3 — owner: backend-dev-1 — priority: P0 — estimate: S

### Phase 4 — Core Backend APIs
- [ ] [TASK-050] GET /api/v1/people with pagination + sort — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-051] GET /api/v1/people filters: title, seniority, location, company — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-052] GET /api/v1/people filters: industry, skills, yearsExperience — phase: 4 — owner: backend-dev-1 — priority: P1 — estimate: M
- [ ] [TASK-053] GET /api/v1/people/[id] — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: S
- [ ] [TASK-054] GET /api/v1/companies with pagination + sort — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-055] GET /api/v1/companies filters: industry, size, location, foundedYear — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-056] GET /api/v1/companies filters: revenueBand, techStack — phase: 4 — owner: backend-dev-1 — priority: P1 — estimate: M
- [ ] [TASK-057] GET /api/v1/companies/[id] — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: S
- [ ] [TASK-058] GET/PATCH /api/v1/me — phase: 4 — owner: backend-dev-2 — priority: P0 — estimate: S
- [ ] [TASK-059] CRUD /api/v1/lists — phase: 4 — owner: backend-dev-2 — priority: P0 — estimate: M
- [ ] [TASK-060] /api/v1/lists/[id]/items add/remove — phase: 4 — owner: backend-dev-2 — priority: P0 — estimate: M
- [ ] [TASK-061] /api/v1/lists/[id]/share with permission — phase: 4 — owner: backend-dev-2 — priority: P1 — estimate: M
- [ ] [TASK-062] POST /api/v1/exports/csv (streaming) — phase: 4 — owner: backend-dev-2 — priority: P1 — estimate: M
- [ ] [TASK-063] Postman collection: complete coverage with Examples — phase: 4 — owner: backend-dev-1 — priority: P0 — estimate: M

### Phase 5 — Frontend MVP
- [ ] [TASK-070] Build SearchBar component — phase: 5 — owner: frontend-dev-2 — priority: P0 — estimate: S
- [ ] [TASK-071] Build FilterPanel + FilterMultiSelect + FilterRange — phase: 5 — owner: frontend-dev-2 — priority: P0 — estimate: L
- [ ] [TASK-072] Build PersonCard + CompanyCard — phase: 5 — owner: frontend-dev-2 — priority: P0 — estimate: M
- [ ] [TASK-073] Build ResultsTable with sort/select rows — phase: 5 — owner: frontend-dev-2 — priority: P0 — estimate: M
- [ ] [TASK-074] Build SaveToListButton + ExportButton — phase: 5 — owner: frontend-dev-2 — priority: P1 — estimate: M
- [ ] [TASK-075] Build EmptyState + LoadingSkeleton + ErrorBoundary — phase: 5 — owner: frontend-dev-2 — priority: P0 — estimate: S
- [ ] [TASK-076] Page: home (`/`) — phase: 5 — owner: frontend-dev-1 — priority: P0 — estimate: S
- [ ] [TASK-077] Page: search (`/search`) with URL-state filters — phase: 5 — owner: frontend-dev-1 — priority: P0 — estimate: L
- [ ] [TASK-078] Page: person profile (`/people/[id]`) — phase: 5 — owner: frontend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-079] Page: company profile (`/companies/[id]`) — phase: 5 — owner: frontend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-080] Page: lists (`/lists`, `/lists/[id]`) — phase: 5 — owner: frontend-dev-1 — priority: P1 — estimate: M
- [ ] [TASK-081] Page: login/signup — phase: 5 — owner: frontend-dev-1 — priority: P1 — estimate: S
- [ ] [TASK-082] Root layout, error.tsx, not-found.tsx, loading.tsx — phase: 5 — owner: frontend-dev-1 — priority: P0 — estimate: S

### Phase 6 — Integration
- [ ] [TASK-090] Wire search page to /api/v1/people + /api/v1/companies — phase: 6 — owner: frontend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-091] Wire profile pages to detail endpoints — phase: 6 — owner: frontend-dev-1 — priority: P0 — estimate: S
- [ ] [TASK-092] Wire lists CRUD + share — phase: 6 — owner: frontend-dev-1 — priority: P1 — estimate: M
- [ ] [TASK-093] Wire CSV export download — phase: 6 — owner: frontend-dev-2 — priority: P1 — estimate: S
- [ ] [TASK-094] Auth flow E2E (login → session → logout) — phase: 6 — owner: frontend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-095] Error → user-friendly toast/banner mapping — phase: 6 — owner: frontend-dev-2 — priority: P0 — estimate: S
- [ ] [TASK-096] URL-state persistence + back-button correctness — phase: 6 — owner: frontend-dev-1 — priority: P0 — estimate: M

### Phase 7 — QA & Polish
- [ ] [TASK-100] e2e suite: search happy path — phase: 7 — owner: qa — priority: P0 — estimate: M
- [ ] [TASK-101] e2e suite: lists + export — phase: 7 — owner: qa — priority: P0 — estimate: M
- [ ] [TASK-102] e2e suite: auth (login, expired, logout) — phase: 7 — owner: qa — priority: P0 — estimate: M
- [ ] [TASK-103] a11y audit on all routes (axe-core) — phase: 7 — owner: qa — priority: P0 — estimate: M
- [ ] [TASK-104] Lighthouse audits (target ≥ 90 perf/a11y/best) — phase: 7 — owner: qa — priority: P0 — estimate: M
- [ ] [TASK-105] Performance: ensure p95 search < 500ms — phase: 7 — owner: backend-dev-1 — priority: P0 — estimate: M
- [ ] [TASK-106] Triage and clear remaining backlog bugs — phase: 7 — owner: pm — priority: P0 — estimate: L

### Phase 8 — Deployment & Docs
- [ ] [TASK-110] Vercel project setup + envs — phase: 8 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-111] release.yml workflow (deploy on tag) — phase: 8 — owner: devops — priority: P0 — estimate: M
- [ ] [TASK-112] README.md: setup, scripts, architecture, deploy — phase: 8 — owner: devops — priority: P0 — estimate: M
- [ ] [TASK-113] CHANGELOG.md: full history v0.1.0 → v1.0.0 — phase: 8 — owner: devops — priority: P0 — estimate: S
- [ ] [TASK-114] Final demo: docs/demos/phase-8.md with run-instructions + screenshots — phase: 8 — owner: pm — priority: P0 — estimate: M
- [ ] [TASK-115] gh release create v1.0.0 — phase: 8 — owner: devops — priority: P0 — estimate: S

---

## Todo

_(empty — PO promotes from Backlog as phases progress)_

---

## Doing

_(empty — agents move tasks here when they start)_

---

## Review

_(empty — agents move tasks here when ready for code review)_

---

## Done

_(empty — QA closes tasks here with `qa: ✓ <date>` and a tag if shipped)_
