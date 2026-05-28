# MAR-1215 Implement Canonical Geo Hub Template for MAR-1213

Date: 2026-05-27
Owner: CTO
Status: Completed

## Scope
Implement and verify the county-aware canonical geo hub template behavior required by MAR-1213 acceptance expectations, without introducing new schema fields or route variants.

## Runtime Implementation

Geo hub template implementation is present at:

- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro`

Implemented behavior:

1. County-aware canonical route params and pathing via `getStaticPaths()` and `/{state}/{county}/{geo}/` route template.
2. First decision surface renders local category exploration using canonical category hrefs.
3. Sparse-data fallback branch exists when local exploration is unavailable.
4. Nearby geo recovery/exploration renders after local decision surface only.
5. Invalid destination suppression is applied to both local and nearby target lists.

Shared navigation helpers used by the template:

- `apps/astro-ssg-thin-slice/src/lib/navigation.ts`
  - `geoHubHref()`
  - `categoryHref()`
  - `nearbyGeoTargets()`
  - `suppressInvalidTargets()`

## Verification

Executed from `apps/astro-ssg-thin-slice` on 2026-05-27:

1. `npm run validate:data` (pass)
2. `npm run validate:routes` (pass)
3. `npm run build` (pass)

Generated geo hub routes:

- `/maryland/baltimore-county/towson/`
- `/maryland/howard-county/columbia/`

Rendered output evidence confirms local-first then nearby ordering:

- `apps/astro-ssg-thin-slice/dist/maryland/baltimore-county/towson/index.html`
- `apps/astro-ssg-thin-slice/dist/maryland/howard-county/columbia/index.html`

Both rendered pages include:

1. `Explore the Directory` section first.
2. `Nearby Places` section after local decision surface.
3. No self-geo nearby link emission due to `suppressInvalidTargets()`.

## Outcome
MAR-1215 canonical geo hub template implementation and bounded verification are complete and aligned to county-aware canonical routing and governed nearby behavior.
