# MAR-1211 CEO Review Note

Date: 2026-05-28
Reviewer: CEO
Issue: MAR-1211
Context: Board review request on the current county-aware canonical-template closeout claim.

## Review Outcome

Disposition recommendation: `blocked`

Unblock owner: CTO

Unblock action:
- restore the missing governed geo-hub, category-page, and listing-page behaviors that MAR-1211 says are closed
- correct the county-aware breadcrumb hierarchy on the category and listing templates
- replace the documentation-only closeout claim with implementation evidence that answers the original parent acceptance scope

## Findings

### 1. MAR-1211 is claiming closeout on documentation alignment, but the parent issue goal is still an implementation gap

Severity: high

Authority:
- `docs/projects/marketgrid/mar-1211-close-canonical-template-acceptance-gaps.md:4`
- wake goal for `MAR-1211`: revise the delivered Astro template implementation so `MAR-1209` satisfies the actual parent acceptance criteria

Evidence:
- `docs/projects/marketgrid/mar-1211-close-canonical-template-acceptance-gaps.md:4` scopes this run to aligning implementation-note route examples with runtime routes
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro:32`
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro:34`
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro:43`

Why this blocks approval:
- the issue goal was to close missing governed template behaviors, not only route-example drift
- the current issue note proves documentation consistency, but it does not prove the geo, category, and listing templates now satisfy the parent review requirements

Required correction:
- update the templates and close-out evidence against the actual parent acceptance scope, then restate MAR-1211 as an implementation closeout rather than a documentation cleanup

### 2. The geo hub still does not implement the required nearby or sparse-data recovery behavior

Severity: high

Authority:
- `docs/design-system/page-assembly-rules.md:123`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md:221`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md:242`

Evidence:
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro:38` renders one local exploration section only
- there is no nearby-geo section after the local exploration surface
- there is no empty-state or sparse-data fallback path in the geo hub template

Why this blocks approval:
- geo-hub authority now explicitly allows nearby recovery only after the first decision surface and requires fallback behavior when local exploration is empty
- the current template does not implement that governed behavior, so the reviewed acceptance gap remains open

Required correction:
- add the post-decision nearby-geo behavior and the sparse-data fallback path without inventing new schema fields

### 3. The category page still stops at listings and omits the governed related/nearby ordering and empty fallback

Severity: high

Authority:
- `docs/design-system/page-assembly-rules.md:164`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md:325`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md:347`

Evidence:
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro:39` renders the listing surface
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro:46` ends the page immediately after listings
- no contextual related-category section appears after listings
- no nearby same-category section appears after contextual links
- no no-listings fallback path is present

Why this blocks approval:
- MAR-1201 defines the category-page order as listings first, then contextual links, then nearby links, with specific empty-state behavior
- the current template still implements only the first decision surface

Required correction:
- add the post-listing contextual and nearby sections in the required order, plus the governed empty-state fallback behavior

### 4. The listing page is missing the required post-action related-link section and the county-aware breadcrumb hierarchy is incomplete

Severity: high

Authority:
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md:393`
- `docs/design-system/design-system-consistency.md:59`
- `docs/projects/marketgrid/mar-1200-linking-breadcrumb-audit.md:59`

Evidence:
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro:49` renders the detail surface
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro:55` only provides a back-to-category secondary action inside the detail surface
- there is no related-link section after the action/detail surface for parent and same-task contextual exits
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro:34` to `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro:40` omits the county structural crumb even though the route is county-aware
- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro:26` to `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro:32` also omits the county structural crumb

Why this blocks approval:
- listing-page authority requires related/contextual exits after the action panel and nearby expansion only after those exits
- breadcrumb authority requires URL-faithful hierarchy; county-aware routes cannot silently drop the county structural level on deeper pages

Required correction:
- add the governed related-link section after the action/detail surface and restore the county structural crumb on category and listing pages

## FAQ Gate

No FAQ output is under review in this slice, so `docs/validators/faq-quality.md` is not triggered for this closeout decision.

## Approval Status

Not approved for closeout.

Closeout condition:
- CTO ships the missing governed template behavior and breadcrumb fix
- close-out evidence demonstrates multi-geo, multi-category, and multi-listing reuse plus invalid-destination suppression against the actual implementation, not only note alignment
