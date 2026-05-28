# MAR-1200 Internal-Linking Authority Audit (Task 7)

Status: Delivered
Issue: MAR-1200
Date: 2026-05-27
Owner: CTO

## Authority Source

- Parent Authority Packet: `MAR-1199` (inherited)
- Authority mode used: packet-consumption only
- Full preflight rerun: not required in this issue (no same-domain authority conflict detected)

## Scope

Audit and complete Task 7 authority behavior before Task 8 page-template implementation:

- `7.1` geo/category/listing linking and breadcrumb authority
- `7.2` nearby/contextual linking behavior (including topical category links)
- `7.3` immediate implementation rules vs future authority-network expansion

This artifact updates the canonical CTO audit outcome and references existing sibling deliverables instead of duplicating systems.

## Inputs Audited

- Runtime/template surface:
  - `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/index.astro`
  - `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/index.astro`
  - `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/[listing]/index.astro`
  - `apps/astro-ssg-thin-slice/src/components/Breadcrumbs.astro`
- Canonical authority docs:
  - `docs/system/site-architecture.md`
  - `docs/system/breadcrumb-system.md`
  - `docs/system/cta-heirarchy-system.md`
  - `docs/system/common-searches-system.md`
  - `docs/system/category-governance-system.md`
- Task-7 sibling artifacts:
  - `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md`
  - `docs/projects/marketgrid/mar-1202-authority-network-expansion-audit.md`
  - `docs/projects/marketgrid/mar-1203-authority-network-expansion-eligibility-rules.md`

## Verification Performed

```bash
cd apps/astro-ssg-thin-slice
npm run -s build
npm run -s validate:data
npm run -s validate:routes
npm run -s build:inspect
```

All checks passed in the prior runtime audit pass for this issue family.

## 7.1 Audit - Geo / Category / Listing Linking

Status: `complete`

- Geo -> category/listing path families resolve within the active thin-slice routes.
- Listing breadcrumb chain was corrected to include `Business Directory` as structural context.
- Breadcrumb behavior remains URL-faithful: non-existent parent routes are represented as non-link structural nodes.
- No schema expansion required for this correction.

## 7.2 Audit - Nearby / Contextual Linking (Including Topical Category Links)

Status: `complete` for current phase policy

- Nearby/contextual placement and ordering contract is covered by MAR-1201.
- Topical category links are explicitly conditional, not default, and must pass route + taxonomy gates under MAR-1203.
- Contextual links must remain same-intent and hierarchy-safe; nearby links remain geo-valid escape paths.
- Placeholder or unresolved destinations are prohibited in implementation-facing artifacts.

## 7.3 Audit - Immediate vs Future Authority-Network Expansion

Status: `complete` for implementation boundary definition

Immediate implementation-safe destination families:

- category page (default demand target)
- listing page (entity-specific only)
- nearby geo hub (recovery/exploration)
- hierarchy-preserving parent context links
- topical hub only when all eligibility gates pass and route exists

Future expansion (out of current implementation scope):

- guide/contextual page destinations
- placeholder destinations
- new taxonomy or new route families

Future expansion is governed by MAR-1203 and requires separate authority approval before template implementation can consume it.

## Link Classification Matrix (Task 7 Requirement)

| Link class | Required now | Conditional now | Prohibited now |
| --- | --- | --- | --- |
| Breadcrumb links | Home/state/geo + valid parents in URL hierarchy | `Business Directory` and `Topical Hub` as non-link structural nodes when route absent | invented levels, reordered hierarchy, URL-inconsistent crumbs |
| CTA links | exactly one primary CTA per page; structural links stay subordinate | secondary/inline CTAs after first decision surface | multiple peer primary CTAs, CTA styling for routine structural navigation |
| Contextual related links | same-intent related category/listing links with valid destinations | topical-hub links only when eligibility + route gates pass | ad hoc taxonomy jumps, placeholder destinations, guide/contextual targets |
| Nearby links | nearby geo hub and nearby same-category links with valid destinations | fallback use in sparse-data empty states after contextual options | current-geo self-links, malformed/disabled links |

## Required Clarifications Confirmed

- Breadcrumb authority behavior: clarified and enforced as structural, URL-faithful hierarchy.
- Nearby geo behavior: clarified as post-decision escape navigation, geo-valid only.
- Related/topical category behavior: classified as conditional with strict eligibility gates.
- CTA link behavior: clarified as single-primary hierarchy with structural link separation.
- Sparse-data behavior: defined through fallback ordering (contextual first, then nearby; no placeholders).

## Gap Outcome

No additional net-new systems were introduced in MAR-1200.

Task 7 authority closure is achieved by:

1. runtime/linking consistency correction in MAR-1200,
2. nearby/contextual placement contract in MAR-1201,
3. expansion audit in MAR-1202,
4. deterministic eligibility rules in MAR-1203.

## Task 8 Unblock

Task 8 page-template implementation is unblocked under the following constraint set:

- implement only destinations allowed by this Task 7 authority closure,
- do not map to guide/contextual or placeholder destinations,
- do not expand schema without explicit authority approval.

## Close-Out Questions (Explicit Answers)

1. Was existing linking and authority behavior audited before proposing new work?
   Answer: Yes. See `Inputs Audited`, `Verification Performed`, and the `7.1/7.2/7.3` audit sections.
2. Was `7.1` geo/category/listing linking assessed and completed or gap-documented?
   Answer: Yes. Completed in `7.1 Audit - Geo / Category / Listing Linking` with no unresolved gaps.
3. Was `7.2` nearby/contextual linking assessed and completed or gap-documented?
   Answer: Yes. Completed for current-phase policy in `7.2 Audit - Nearby / Contextual Linking`.
4. Did `7.2` explicitly evaluate topical category links?
   Answer: Yes. Topical category behavior is explicitly classified as conditional and gate-based in `7.2` and the `Link Classification Matrix`.
5. Did `7.3` separate immediate requirements from future authority-network expansion?
   Answer: Yes. Immediate vs future boundaries are explicit in `7.3 Audit - Immediate vs Future Authority-Network Expansion`.
6. Were existing docs updated/referenced instead of duplicating systems?
   Answer: Yes. This artifact references MAR-1201/1202/1203 as canonical sibling closures and does not create parallel systems.
7. Are required, conditional, and prohibited links clarified?
   Answer: Yes. The `Link Classification Matrix` explicitly classifies required/conditional/prohibited behavior.
8. Is breadcrumb authority behavior clarified?
   Answer: Yes. Clarified in `7.1` and `Required Clarifications Confirmed` as structural and URL-faithful.
9. Is nearby geo behavior clarified?
   Answer: Yes. Clarified in `7.2`, the matrix, and `Required Clarifications Confirmed` as geo-valid recovery/exploration only.
10. Is related/topical category behavior classified?
    Answer: Yes. Classified as contextual-required vs topical-conditional with MAR-1203 eligibility gates.
11. Is CTA link behavior clarified?
    Answer: Yes. Clarified in the matrix and `Required Clarifications Confirmed` as single-primary with subordinate structural navigation.
12. Is sparse-data behavior defined?
    Answer: Yes. Defined in `Required Clarifications Confirmed` and inherited placement/fallback policy from MAR-1201.
13. Was full page-template implementation avoided in this issue?
    Answer: Yes. This issue is audit/policy only; no page-template realization work is performed here.
14. Was schema expansion avoided unless explicitly approved?
    Answer: Yes. `7.1` states no schema expansion required; no new schema fields are introduced in this artifact.
15. Is Task 8 page-template implementation unblocked?
    Answer: Yes. See `Task 8 Unblock` with explicit constraint set.
16. Are breadcrumb structural non-link rules for absent routes explicit?
    Answer: Yes. `7.1` states absent-route parents remain non-link structural nodes to preserve hierarchy fidelity.
17. Are nearby/contextual placeholder or unresolved destinations prohibited for implementation?
    Answer: Yes. `7.2` and the matrix explicitly prohibit placeholder/unresolved destinations.
18. Is the implementation boundary to current approved destination families explicit?
    Answer: Yes. `7.3` and `Task 8 Unblock` limit implementation to approved families and defer expansion to MAR-1203 governance.

## Final Disposition

`done` - Task 7 internal-linking authority model is audited, closed, and implementation-ready for Task 8 within the current scope boundary.
