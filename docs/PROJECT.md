# Apollo-like — Project Brief

## What we're building

A web app that lets users **search global company and people data** (LinkedIn-style), filter by rich criteria, save results to lists, and export to CSV. Inspirations: apollo.io, lusha.com, cognism.com.

## Target user

A sales rep, recruiter, or researcher who needs to find decision-makers or companies that match a profile. They live in this app for hours a day. Speed and filter UX matter more than aesthetics.

## Core features (MVP — phases 1–6)

- **People search**: filter by job title, seniority, location, company, industry, skills, years of experience
- **Company search**: filter by industry, size, location, revenue band, technology stack, founding year
- **Detail pages**: full profile for each person and company
- **Saved lists**: create, rename, share (view/edit), soft-delete
- **CSV export**: streaming, RFC-4180 compliant, file naming convention
- **Auth**: email + Google (Auth.js v5 with JWT sessions)
- **Responsive**: works on mobile (375px) up

## Stretch (post-v1.0)

- Email enrichment (find email by name+company)
- Phone enrichment
- Bulk-action toolbar
- CRM integrations (HubSpot, Salesforce)
- Saved searches / alerts
- Team workspaces

## Data strategy

LinkedIn doesn't expose a useful public API for scraping, so we use:
- **Phase 3**: a 5K-company / 20K-people **seed dataset** generated with Faker, kept consistent (companies → employees, employees → roles, etc.) — realistic enough to demo the search UX.
- **Adapter pattern** in `apps/web/lib/providers/` so we can swap a real provider (Proxycurl, Apollo Engage, PeopleDataLabs) without touching UI.

The seed data is **the API contract** during development; switching providers is a phase-9 stretch.

## Quality bar

- TypeScript strict, zero `any`, zero `as` casts beyond I/O boundary
- Test coverage ≥ 70% lines for app code
- e2e suite at 100% green for every release tag
- a11y: zero serious/critical violations on shipped pages
- Lighthouse: ≥ 90 on perf, a11y, best-practices for `/`, `/search`, profile pages

## Decisions log

This section records non-obvious product decisions. Each entry: date, decision, why.

> _PO will append to this section as decisions are made. Format:_
>
> ### YYYY-MM-DD — <decision title>
> **Decision:** ...
> **Why:** ...
> **Alternatives considered:** ...
