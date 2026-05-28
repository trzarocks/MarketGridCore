# MAR-1194 CTO Plan: Astro Realization for the MarketGrid Design System

Date: 2026-05-27  
Owner: CTO  
Issue: MAR-1194  
Mode: Planning artifact only (no runtime code changes in this issue)

## Objective

Define a deterministic, low-risk implementation plan to realize the existing MarketGrid design system inside `apps/astro-ssg-thin-slice` without introducing new systems, while preserving current authority boundaries and deployment contracts.

## Scope

In scope:
- Astro thin-slice app structure and rendering contracts
- Design-system realization mapping into reusable Astro components/layout wrappers
- Validation and rollout sequence for geo/category/listing pages already in thin slice

Out of scope:
- Content strategy or copy rewrites
- New page types or route families
- Schema-contract redesign
- New runtime platform outside current Astro thin-slice stack

## Authority Inputs Used

- `/docs/agents/cto-start-here.md`
- `/docs/system/core-agent-protocol.md`
- `/docs/system/authority-consumption.md`
- `/docs/system/guardrails.md`
- `/docs/system/role-based-ingestion-map.md`
- `/docs/system/agent-execution-contract.md`
- `/docs/system/system-map.md`
- `/docs/system/site-architecture.md`
- `/docs/system/schema-contract.md`
- `/docs/system/cmo-cto-content-handoff-governance.md`
- `/docs/design-system/design.md`
- `/docs/system/design-system.md`
- `/docs/system/component-library.md`
- `/docs/implementation/page-generation-pipeline.md`
- `/docs/deployment/astro-ssg-deployment-contract.md`
- `/docs/deployment/astro-thin-slice-workflow.md`
- `/docs/validators/astro-deployment-validation.md`

## Current-State Technical Read

1. Astro thin slice already has route templates and deployment-validation scripts in place.
2. Visual authority is explicitly anchored to the existing MarketGrid prototype style and must not regress to generic rendering.
3. Deployment contract and validator sequence are already deterministic; realization work should plug into these gates, not replace them.
4. System/page hierarchy is fixed (geo -> directory/category -> listing) and must remain URL-faithful with single-primary-CTA behavior.

## Target Realization Outcome

The Astro app should render MarketGrid pages through reusable, design-system-aligned components while preserving:

1. Existing route contract and breadcrumb fidelity.
2. Existing required data/validation hard-fail rules.
3. Existing deployment workflow and artifact contract.
4. Existing page-purpose boundaries from system/page authorities.

## Technical Plan

### Phase 1: Baseline and Contract Lock

Deliverables:
1. Create a design realization matrix for current Astro pages:
- `src/pages/[state]/[geo]/index.astro`
- `src/pages/[state]/[geo]/business-directory/[category]/index.astro`
- `src/pages/[state]/[geo]/business-directory/[category]/[listing]/index.astro`
2. Map each page section to canonical design-system/component selectors (`.page-section`, `.section-shell`, `.section-header`, CTA pattern, breadcrumb pattern).
3. Freeze an initial visual baseline snapshot from current build for regression checks.

Verification gates:
- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`

Exit condition:
- Matrix complete and no contract failures introduced.

### Phase 2: Shared Layout Primitive Extraction

Deliverables:
1. Introduce shared Astro layout primitives under `src/components/` for:
- Page shell/container rhythm
- Breadcrumb rendering
- Section wrapper/header composition
- Primary/secondary CTA slotting
2. Keep rendering presentational only; no authority logic moves into components.
3. Preserve page input contracts exactly as currently validated.

Verification gates:
- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`
- `npm run build:inspect`

Exit condition:
- Shared primitives adopted with no route or artifact drift.

### Phase 3: Page-by-Page Realization

Deliverables:
1. Geo page refactor to shared primitives.
2. Category page refactor to shared primitives.
3. Listing page refactor to shared primitives.
4. Confirm one-primary-CTA behavior per page per execution contract.

Verification gates:
- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`
- `npm run build:inspect`
- `npm run generate:sitemap`

Exit condition:
- All thin-slice page templates realized via shared primitives and passing validation.

### Phase 4: Deployment-Readiness and Promotion Evidence

Deliverables:
1. Run full thin-slice workflow contract.
2. Produce deployment evidence bundle (command evidence, artifact evidence, route evidence).
3. Confirm required output artifacts and sitemap contract.

Verification gates:
- `npm ci`
- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`
- `npm run preview` (required when snapshot/templates changed)
- `npm run build:inspect`
- `npm run generate:sitemap`

Exit condition:
- Release-candidate artifact is promotable per deployment contract.

## Work Breakdown for Implementation Issues

1. Slice A: Realization matrix + baseline snapshot + no-code contract confirmation.
2. Slice B: Shared primitives scaffold and non-breaking adoption in one page (geo).
3. Slice C: Category/listing migration to shared primitives.
4. Slice D: Deployment-evidence run and promotion handoff package.

Each slice should be a child issue with independent acceptance evidence to avoid long-running in-progress loops.

## Risk Register and Mitigations

1. Risk: Visual drift toward generic output during refactor.
- Mitigation: baseline snapshot + explicit selector-level mapping + design-authority checks in PR review.

2. Risk: Breadcrumb or route-context regressions.
- Mitigation: keep breadcrumbs URL-derived and validate route templates before/after each slice.

3. Risk: CTA hierarchy violations after component extraction.
- Mitigation: enforce a primary CTA slot and explicit secondary-action slots in shared components.

4. Risk: Schema metadata rendering breaks when moving head logic.
- Mitigation: leave schema payload shape untouched; only relocate rendering wrappers with parity checks.

5. Risk: Deployment evidence gaps block promotion.
- Mitigation: require gate-by-gate command/output evidence as part of slice D definition of done.

## Acceptance Criteria for MAR-1194

1. A phased Astro realization plan exists with explicit deliverables and gates.
2. Plan extends current systems/contracts only (no new runtime system introduced).
3. Page hierarchy, breadcrumb, CTA, and schema-contract constraints are explicitly preserved.
4. Implementation-ready slice breakdown is provided for child issue creation.
5. Validation and deployment evidence expectations are defined per existing contracts.

## Disposition Recommendation

Set MAR-1194 to `done` once this plan is attached to the issue and approved as the implementation blueprint. Follow-on execution should proceed through child implementation issues (Slices A-D).
