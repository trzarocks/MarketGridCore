# MAR-1207 Route Verification and Contract Alignment

## Scope

Verify that the Astro thin-slice runtime emits county-aware geo routes from the active snapshot and confirm route/deployment contracts are aligned to the same canonical hierarchy.

## Verification Run

Executed in `apps/astro-ssg-thin-slice` on 2026-05-27:

1. `npm run validate:data` (pass)
2. `npm run validate:routes` (pass)
3. `npm run build` (pass)
4. `npm run build:inspect` (pass)
5. `node scripts/generate-sitemap.mjs` (pass)

## Emitted Route Evidence

Build output and `build:inspect` confirm county-aware paths are emitted:

- `/maryland/`
- `/maryland/baltimore-county/towson/`
- `/maryland/baltimore-county/towson/business-directory/restaurants/`
- `/maryland/baltimore-county/towson/business-directory/restaurants/banditos-bar-and-kitchen/`
- `/maryland/howard-county/columbia/`
- `/maryland/howard-county/columbia/business-directory/plumbers/`
- `/maryland/howard-county/columbia/business-directory/plumbers/saffer-plumbing-and-heating/`
- `/maryland/howard-county/columbia/business-directory/plumbers/heil-plumbing-dsm/`
- `/maryland/howard-county/columbia/business-directory/plumbers/prime-plumbing/`

`sitemap.xml` was generated at:

- `apps/astro-ssg-thin-slice/dist/sitemap.xml`

with `10` URLs matching the emitted static route inventory.

## Contract Alignment Check

Verified both authority docs reflect the same county-aware canonical templates and URL rules:

1. `docs/runtime/rendering/astro-route-generation-contract.md`
   - canonical templates include `[state]/[county]/[geo]/...`
   - concrete route rules define `/{state}/{county}/{geo}/...`
   - uniqueness scope defines `geo-slug` uniqueness by `(state, county)`

2. `docs/deployment/astro-ssg-deployment-contract.md`
   - required input templates include `[state]/[county]/[geo]/...`
   - required output artifacts include county-aware `dist` paths
   - geo/category/listing input contracts require `county.slug`

## Disposition

No contract drift detected between runtime emission and contract documentation for county-aware geo routing. MAR-1207 verification is complete.
