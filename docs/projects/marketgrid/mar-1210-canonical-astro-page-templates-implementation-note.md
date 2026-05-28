# MAR-1210 Canonical Astro Page Templates Implementation Note

## Scope

Implement canonical Astro page templates for the MarketGrid thin-slice route hierarchy, aligned to county-aware path contracts.

## Implemented Runtime Surface

Canonical template files are present under `apps/astro-ssg-thin-slice/src/pages`:

1. `index.astro`
2. `[state]/index.astro`
3. `[state]/[county]/[geo]/index.astro`
4. `[state]/[county]/[geo]/business-directory/[category]/index.astro`
5. `[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro`

Legacy non-county templates under `[state]/[geo]/...` were removed from the route template surface.

## Contract Alignment

Supporting runtime contracts and validators align with county-aware canonical routes:

- Route validator requires all five county-aware templates:
  - `apps/astro-ssg-thin-slice/scripts/validate-routes.mjs`
- Snapshot validator enforces county presence and route-key uniqueness:
  - `apps/astro-ssg-thin-slice/scripts/validate-snapshot.mjs`
- Sitemap generator emits county-aware URLs:
  - `apps/astro-ssg-thin-slice/scripts/generate-sitemap.mjs`
- Route contract doc defines county-aware canonical patterns:
  - `docs/runtime/rendering/astro-route-generation-contract.md`

## Verification Evidence

Executed from `apps/astro-ssg-thin-slice`:

1. `npm run validate:data`
2. `npm run validate:routes`
3. `npm run build`

Result: all commands passed.

Build emitted county-aware routes, including:

1. `/maryland/baltimore-county/towson/`
2. `/maryland/baltimore-county/towson/business-directory/restaurants/`
3. `/maryland/baltimore-county/towson/business-directory/restaurants/banditos-bar-and-kitchen/`
4. `/maryland/howard-county/columbia/business-directory/plumbers/`
5. `/maryland/howard-county/columbia/business-directory/plumbers/prime-plumbing/`

## Outcome

`MAR-1210` implementation objective is satisfied for canonical Astro page template realization on the county-aware route hierarchy.
