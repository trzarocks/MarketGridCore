# MAR-1216 Close MAR-1213 Acceptance Evidence Gaps

Date: 2026-05-27
Owner: CTO
Status: Completed

## Scope
Close acceptance evidence gaps for `MAR-1213` by supplying implementation-grounded proof for canonical geo-hub behavior in the county-aware Astro template surface, without introducing schema or route-contract changes.

## Implementation Reference

Geo hub runtime implementation under review:

- `apps/astro-ssg-thin-slice/src/pages/[state]/[county]/[geo]/index.astro`

Supporting navigation guardrails used by the template:

- `apps/astro-ssg-thin-slice/src/lib/navigation.ts`
  - `nearbyGeoTargets()`
  - `suppressInvalidTargets()`

## Acceptance Evidence

### 1. Bounded validation and build pass

Executed from repo root on 2026-05-27:

1. `npm --prefix apps/astro-ssg-thin-slice run validate:data` (pass)
2. `npm --prefix apps/astro-ssg-thin-slice run validate:routes` (pass)
3. `npm --prefix apps/astro-ssg-thin-slice run build` (pass)

Build emitted county-aware geo hubs:

- `/maryland/baltimore-county/towson/`
- `/maryland/howard-county/columbia/`

### 2. Geo-hub section ordering proof (local first, nearby second)

Rendered pages:

- `apps/astro-ssg-thin-slice/dist/maryland/baltimore-county/towson/index.html`
- `apps/astro-ssg-thin-slice/dist/maryland/howard-county/columbia/index.html`

Deterministic check:

- `towson order true` for `Explore the Directory` before `Nearby Places`
- `columbia order true` for `Explore the Directory` before `Nearby Places`

### 3. Invalid-destination suppression proof (no self-geo links)

Rendered self-link counts:

1. `grep -oF 'href="/maryland/baltimore-county/towson/"' .../towson/index.html | wc -l` => `0`
2. `grep -oF 'href="/maryland/howard-county/columbia/"' .../columbia/index.html | wc -l` => `0`

This confirms `suppressInvalidTargets()` is preventing self-target nearby emission for both sample geos.

## Outcome

`MAR-1213` acceptance evidence gaps are closed for canonical geo-hub behavior:

1. county-aware geo-hub routes build successfully,
2. local decision surface renders before nearby recovery,
3. self-target invalid links are suppressed in emitted output.
