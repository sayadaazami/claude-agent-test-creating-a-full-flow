# Phases

The project ships in 8 phases. Each phase ends with a `git tag v0.<phase>.0` and a demo file under `docs/demos/phase-<N>.md`.

A phase is **Done** when:
- All its tasks are in the `Done` column of [tasks.md](tasks.md) with `qa: ✓`
- A `code-reviewer` review with verdict `approve` exists for every code-affecting task
- A QA report at the bottom of the phase confirms e2e suite is green
- A demo file is created and runnable

---

## Phase 1 — Discovery & Spec
**Tag:** `v0.1.0`
**Lead:** PO + PM
**Outcome:** Project brief, refined backlog for phases 1–4 in [tasks.md](tasks.md), high-level architecture in [ARCHITECTURE.md](ARCHITECTURE.md).
**Acceptance:**
- [PROJECT.md](PROJECT.md) finalized (all sections filled)
- 25+ tasks refined with full spec template (story + acceptance + dependencies)
- Phase 1 tasks Done

## Phase 2 — UX/UI Design
**Tag:** `v0.2.0`
**Lead:** UX Designer + PO review
**Outcome:** Design tokens, component specs, wireframes for all MVP pages.
**Acceptance:**
- `docs/design/tokens.md` — colors, type, spacing, radii, shadows
- `docs/design/components/` — specs for ≥ 12 reusable components
- `docs/design/wireframes/` — wireframes for: home, search, results, person profile, company profile, lists index, list detail, login
- `docs/design/flows/` — search flow, auth flow

## Phase 3 — Foundation & Architecture
**Tag:** `v0.3.0`
**Leads:** DevOps + BE-1 + BE-2 (parallel)
**Outcome:** Buildable monorepo with Next.js skeleton, Prisma schema, seed data, CI green.
**Acceptance:**
- `pnpm install && pnpm build` succeeds from scratch
- `pnpm dev` boots Next.js at `http://localhost:3000`
- `apps/web/prisma/schema.prisma` defined for User, Person, Company, List, ListItem, ListShare
- `pnpm seed` populates 5K companies / 20K people locally
- GitHub Actions `ci.yml` green
- Auth.js scaffolded with email + Google provider

## Phase 4 — Core Backend APIs
**Tag:** `v0.4.0`
**Leads:** BE-1 (search) + BE-2 (auth/lists) — FE may begin scaffolding using Postman mocks
**Outcome:** All v1 endpoints live with tests + Postman collection.
**Acceptance:**
- `GET /api/v1/people` and `GET /api/v1/companies` with at least 8 filters each, pagination, sort
- `GET /api/v1/people/[id]`, `GET /api/v1/companies/[id]`
- Auth.js working: `/api/auth/*`, `GET /api/v1/me`, `PATCH /api/v1/me`
- Lists CRUD: `GET/POST/PATCH/DELETE /api/v1/lists`, items CRUD, share endpoint
- `POST /api/v1/exports/csv` streaming
- Postman collection covers every endpoint with examples
- Integration tests at ≥ 70% line coverage on `app/api/`

## Phase 5 — Frontend MVP
**Tag:** `v0.5.0`
**Leads:** FE-1 (pages) + FE-2 (components) — parallel
**Outcome:** All MVP pages built against the API (or mock when needed), all components from spec.
**Acceptance:**
- All routes from PROJECT.md render with real or mocked data
- All components from `docs/design/components/` implemented + design-fidelity checked
- All states (loading, error, empty, default, focused) implemented per spec
- Mobile responsive at 375/768/1280
- a11y violations: zero serious/critical (axe scan)

## Phase 6 — Integration
**Tag:** `v0.6.0`
**Leads:** BE + FE pair work
**Outcome:** End-to-end real-data flow, error handling, loading states wired.
**Acceptance:**
- `pnpm dev` → search → results → profile → save to list → export CSV works end-to-end
- All errors from API surface as user-friendly messages (not raw stack traces)
- Loading skeletons during fetches
- URL state for filters/pagination (back-button works)

## Phase 7 — QA & Polish
**Tag:** `v0.7.0`
**Lead:** QA — all agents fix
**Outcome:** Production-ready quality.
**Acceptance:**
- e2e suite: 100% green
- Lighthouse on `/`, `/search`, `/people/[id]`: perf ≥ 90, a11y ≥ 95, best-practices ≥ 95
- All bugs in `tasks.md` Backlog cleared (or moved to post-v1.0)
- Performance: p95 search response < 500ms locally with seed data
- 70%+ line coverage on app code

## Phase 8 — Deployment & Docs
**Tag:** `v1.0.0`
**Leads:** DevOps + PM
**Outcome:** Public deploy + finalized documentation.
**Acceptance:**
- Vercel deployment of `apps/web` from `main`
- `release.yml` workflow auto-deploys on `v*` tags
- `README.md` covers: setup, scripts, architecture, deploy
- `CHANGELOG.md` complete from v0.1.0 → v1.0.0
- Final demo at `docs/demos/phase-8.md` with run-instructions and screenshots
- GitHub release created via `gh release create`
