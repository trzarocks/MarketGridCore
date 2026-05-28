# MAR-1211 Close Canonical Template Acceptance Gaps

## Scope
Close remaining acceptance gaps in the actual Astro template implementation so parent issue `MAR-1209` acceptance behavior is satisfied across geo hub, category, and listing templates.

## Gaps Closed

1. Implemented governed post-decision nearby navigation and sparse-data recovery behavior in geo-hub template.
2. Implemented governed category-page ordering and fallback behavior:
   - listings surface first
   - contextual related-category section second (when valid)
   - nearby same-category section third (when valid)
   - no-listings fallback panel while preserving valid contextual/nearby exits
3. Implemented listing-page post-action related-link section with contextual exits first and nearby expansion only after contextual exits.
4. Restored county-aware breadcrumb structural level on category and listing templates.
5. Added reusable invalid-destination suppression helper to remove malformed, duplicate, and self-target links before rendering.

## Files Updated

1. `apps/astro-ssg-thin-slice/src/lib/navigation.ts`
   - Shared href builders and target filtering/suppression.
2. `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro`
   - Geo-hub nearby section and sparse-data fallback path.
3. `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro`
   - County breadcrumb crumb, required section ordering, and no-listings fallback path.
4. `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro`
   - County breadcrumb crumb plus post-action related/contextual/nearby section ordering.

## Verification

Executed in `apps/astro-ssg-thin-slice` on 2026-05-28:

1. `npm run validate:data` (pass)
2. `npm run validate:routes` (pass)
3. `npm run build` (pass)

Observed canonical emitted routes (multi-geo, multi-category, multi-listing reuse):

- `/maryland/`
- `/maryland/baltimore-county/towson/`
- `/maryland/baltimore-county/towson/business-directory/restaurants/`
- `/maryland/baltimore-county/towson/business-directory/restaurants/banditos-bar-and-kitchen/`
- `/maryland/howard-county/columbia/`
- `/maryland/howard-county/columbia/business-directory/plumbers/`
- `/maryland/howard-county/columbia/business-directory/plumbers/saffer-plumbing-and-heating/`

Rendered-output evidence:

1. Geo hub includes first local decision surface followed by nearby section:
   - `dist/maryland/baltimore-county/towson/index.html`
   - `dist/maryland/howard-county/columbia/index.html`
2. Category pages preserve county crumb and listing-first flow:
   - `dist/maryland/baltimore-county/towson/business-directory/restaurants/index.html`
   - `dist/maryland/howard-county/columbia/business-directory/plumbers/index.html`
3. Listing pages preserve county crumb and post-action continue-exploring section:
   - `dist/maryland/baltimore-county/towson/business-directory/restaurants/banditos-bar-and-kitchen/index.html`
   - `dist/maryland/howard-county/columbia/business-directory/plumbers/saffer-plumbing-and-heating/index.html`
4. Invalid destination suppression:
   - self-targets and duplicate targets are dropped by `suppressInvalidTargets()` in `src/lib/navigation.ts`
   - no self-geo nearby links are rendered in generated geo-hub pages
   - no current-listing self-links are rendered in generated listing pages

## Outcome
Canonical template behavior now matches the governed acceptance scope called out in MAR-1211 CEO review: nearby/contextual ordering, sparse-data fallback handling, county-aware breadcrumb structure, and invalid target suppression are implemented in runtime templates.

## Disposition

`in_review`

Implementation and evidence are ready for reviewer verification against MAR-1209 acceptance scope.
