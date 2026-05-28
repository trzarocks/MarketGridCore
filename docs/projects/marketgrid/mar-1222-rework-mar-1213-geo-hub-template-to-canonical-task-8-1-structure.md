# MAR-1222 Rework MAR-1213 Geo Hub Template To Canonical Task 8.1 Structure

Date: 2026-05-28
Owner: CTO
Status: Completed

## Scope
Apply a targeted rework to the county-aware geo hub template so Task 8.1 structure remains canonical under sparse-data and invalid-target conditions, without adding schema fields, routes, or new systems.

## Authority Alignment
- `docs/design-system/page-assembly-rules.md`
- `docs/projects/marketgrid/mar-1200-linking-breadcrumb-audit.md`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md`

## Implementation
Updated:
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro`

Change made:
1. Hero primary CTA is now derived from validated first-decision-surface targets (`localCategoryTargets[0]`) and omitted when no valid local exploration target exists.

Why:
- Prevents emitting a primary hero action that is not backed by the active canonical first decision surface.
- Preserves canonical ordering and sparse-data fallback behavior (local decision surface first; nearby recovery after).

## Verification
Executed from `apps/astro-ssg-thin-slice` on 2026-05-28:
1. `npm run -s build` (pass)

Build output confirms county-aware routes are still emitted for geo hub, category, and listing templates.

## Constraints Check
- New schema fields: none
- Route contract changes: none
- New subsystems: none

## Outcome
Geo hub template behavior is reworked to canonical Task 8.1 structural expectations for action gating while preserving existing county-aware routing and section-order behavior.
