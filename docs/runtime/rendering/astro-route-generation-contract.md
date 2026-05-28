# Astro Route Generation Contract

## Purpose

Define how the Astro thin slice turns approved MarketGrid inputs into static routes.

## Route Contract

The route set is fixed by the existing page tree:

1. Homepage
2. State page
3. Geo hub page
4. Category page
5. Listing page

The canonical templates are:

- `src/pages/index.astro`
- `src/pages/[state]/index.astro`
- `src/pages/[state]/[county]/[geo]/index.astro`
- `src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro`
- `src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro`

## URL Rules

1. Generated URLs must be lowercase and slug-safe.
2. Nested output must match the existing route hierarchy.
3. Canonical output must not create duplicate route variants for the same content.
4. Stale output must not survive a clean rebuild.
5. Sitemap entries must reflect the emitted static routes.

## Concrete Route Rules

All approved records must resolve to these canonical patterns:

1. State route: `/{state-slug}/`
2. Geo hub route: `/{state-slug}/{county-slug}/{geo-slug}/`
3. Category route: `/{state-slug}/{county-slug}/{geo-slug}/business-directory/{category-slug}/`
4. Listing route: `/{state-slug}/{county-slug}/{geo-slug}/business-directory/{category-slug}/{listing-slug}/`

Canonical examples required by this contract:

1. `/maryland/`
2. `/maryland/baltimore-county/towson/`
3. `/maryland/baltimore-county/towson/business-directory/plumbers/`
4. `/maryland/baltimore-county/towson/business-directory/restaurants/`
5. `/maryland/baltimore-county/towson/business-directory/plumbers/example-business/`

Slug rules:

1. Lowercase alphanumeric with hyphens only.
2. No leading or trailing hyphens.
3. No duplicate hyphen runs.
4. No locale or query suffixes in canonical route paths.
5. `state-slug` must be globally unique for active thin-slice states.
6. `county-slug` uniqueness is scoped to a state.
7. `geo-slug` uniqueness is scoped to `(state, county)`.
8. `category-slug` uniqueness is scoped to `(state, county, geo)`.
9. `listing-slug` uniqueness is scoped to `(state, county, geo, category)`.

## Duplicate Detection

Duplicate route emission is a hard failure when:

1. Two different source records target the same canonical URL.
2. One source record would produce multiple canonical outputs for the same route.
3. A redirect or alias would mask a canonical collision.

## Stale Route Removal

A clean build must remove stale generated output that is no longer supported by the current source snapshot or route templates.

Required behavior:

1. Removed source records remove their matching emitted routes in the next clean build.
2. Sitemap output must exclude removed routes in the same run.
3. Stale route presence after clean build is a hard failure.

## Redirect Policy

Redirects are allowed only if they are already expressed by the approved runtime contract.

If no redirect contract exists, do not invent one for deployment convenience.

For this thin-slice contract, no redirect layer is assumed. Any redirect manifest introduced without explicit contract approval is a hard failure.

## Verification Expectations

The route generation contract is satisfied only when:

1. Each required page template exists.
2. The build emits the expected route set.
3. The output can be inspected and matched to the route hierarchy.

## References

- `docs/system/site-architecture.md`
- `docs/system/system-map.md`
- `docs/implementation/page-generation-pipeline.md`
