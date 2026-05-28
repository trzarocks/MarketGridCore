# Astro SSG Deployment Contract

## Purpose

Define the canonical build-and-deploy contract for `apps/astro-ssg-thin-slice`.

This document is deployment authority for the Astro thin-slice workflow. It maps into the existing MarketGrid system contracts and does not override `docs/system/*`, `docs/pages/*`, `docs/schema/*`, or `docs/geo/*`.

## Scope

In scope:
- `apps/astro-ssg-thin-slice`
- Static build output under `apps/astro-ssg-thin-slice/dist`
- CI and local validation for deploy readiness

Out of scope:
- Content strategy
- UX redesign
- New runtime systems outside the existing Astro SSG app and scripts

## Required Inputs

1. Source data snapshot: `apps/astro-ssg-thin-slice/src/data/thin-slice.json`
2. Route templates:
   - `src/pages/index.astro`
   - `src/pages/[state]/index.astro`
   - `src/pages/[state]/[county]/[geo]/index.astro`
   - `src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro`
   - `src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro`
3. Astro static build config: `apps/astro-ssg-thin-slice/astro.config.mjs`
4. Lockfile: `apps/astro-ssg-thin-slice/package-lock.json`
5. Deployment workflow contract: `docs/deployment/astro-thin-slice-workflow.md`
6. Route generation contract: `docs/runtime/rendering/astro-route-generation-contract.md`
7. Validation contract: `docs/validators/astro-deployment-validation.md`

## Input Data Contract

Astro is a deterministic renderer. It does not infer missing business data and does not generate content authority fields.

### Geo Hub Input

Required fields:
- `state.slug` (lowercase, URL-safe)
- `county.slug` (lowercase, URL-safe)
- `geo.slug` (lowercase, URL-safe city slug)
- `geo.displayName`
- `geo.canonicalUrl`
- `breadcrumbs` (valid hierarchy to geo page)
- `schemaMetadata` (organization/location payload object)

Optional fields:
- `hero`
- `intro`
- `relatedLinks`
- `faq`

Hard fail conditions:
- Missing `state.slug`, `county.slug`, `geo.slug`, or `geo.canonicalUrl`
- Breadcrumb chain not rooted in homepage -> state -> geo
- `geo.canonicalUrl` does not match generated geo route

### Category Input

Required fields:
- `state.slug`
- `county.slug`
- `geo.slug`
- `category.slug`
- `category.displayName`
- `category.canonicalUrl`
- `breadcrumbs`
- `schemaMetadata`
- `relatedLinks`

Optional fields:
- `faq`
- `ctaActionPanel`

Hard fail conditions:
- Missing any required field above
- Category canonical collision with another category in same geo
- Empty or invalid `relatedLinks` structure

### Listing Input

Required fields:
- `state.slug`
- `county.slug`
- `geo.slug`
- `category.slug`
- `listing.slug`
- `listing.displayName`
- `listing.canonicalUrl`
- `listing.contact` (at least one of `phone`, `website`, `address`)
- `breadcrumbs`
- `ctaActionPanel` (at least one actionable link)
- `schemaMetadata`

Optional fields:
- `faq`
- `relatedLinks`
- `listing.hours`

Hard fail conditions:
- Missing listing slug/name/canonical
- Missing required contact/action data
- Listing canonical does not conform to listing route pattern
- Invalid schema object for listing entity

### Shared Blocks

`breadcrumbs` required shape:
- Ordered list of breadcrumb nodes with `label` and `url`
- Final node must match page canonical URL

`faq` optional shape:
- Array of question/answer objects
- When present, each item must include non-empty `question` and `answer`

`ctaActionPanel` required on listing, optional elsewhere:
- At least one action with label and destination

`relatedLinks` required on category, optional elsewhere:
- Non-empty array of internal links with canonical URLs

`schemaMetadata` required on geo/category/listing:
- JSON-LD compatible object payload
- Must pass schema payload structural validation

## Contract Model

The Astro thin-slice deploy contract has six fixed phases:

1. Input validation
2. Route generation validation
3. Static build
4. Local preview gate (`npm run preview`) when required by workflow rules
5. Output verification and sitemap generation
6. Deployment handoff (validated `dist/` release-candidate artifact)

The contract is intentionally deterministic. If a required input is missing, the run fails instead of guessing or interpolating fallback behavior.

## Required Output Artifacts

A successful deployment run must produce:

1. `apps/astro-ssg-thin-slice/dist/index.html`
2. `apps/astro-ssg-thin-slice/dist/maryland/index.html`
3. `apps/astro-ssg-thin-slice/dist/maryland/baltimore-county/towson/index.html`
4. `apps/astro-ssg-thin-slice/dist/maryland/baltimore-county/towson/business-directory/restaurants/index.html`
5. `apps/astro-ssg-thin-slice/dist/maryland/baltimore-county/towson/business-directory/restaurants/banditos-bar-and-kitchen/index.html`
6. `apps/astro-ssg-thin-slice/dist/sitemap.xml`

## MarketGrid Section to Astro Responsibility Mapping

| MarketGrid section | Astro component/render responsibility | Contract type |
| --- | --- | --- |
| Geo hub | `src/pages/[state]/[county]/[geo]/index.astro` renders approved geo snapshot fields only | Presentational |
| Category | `src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro` renders approved category/related-link blocks | Presentational |
| Listing | `src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro` renders approved listing/contact/action blocks | Presentational |
| Breadcrumbs | Shared breadcrumb renderer consumes validated breadcrumb arrays | Render-rule enforcing |
| FAQ | Shared FAQ renderer consumes validated FAQ items | Render-rule enforcing |
| CTA/action panel | Shared CTA/action renderer requires valid action targets where required | Render-rule enforcing |
| Related links | Shared related-link renderer requires internal canonical links | Render-rule enforcing |
| Schema metadata | JSON-LD serializer writes validated schema payloads into page head | Render-rule enforcing |

Presentational responsibilities define where approved data is rendered. Render-rule enforcing responsibilities must reject invalid structures according to `docs/validators/astro-deployment-validation.md`.

## Local Workflow

Run from `apps/astro-ssg-thin-slice`:

```bash
npm ci
npm run validate:data
npm run validate:routes
npm run build
npm run preview
npm run build:inspect
npm run generate:sitemap
```

Then verify the required artifacts exist in `dist/` and complete release-candidate deployment handoff as defined in `docs/deployment/astro-thin-slice-workflow.md`.

Preview is required before promotion when snapshot data or route templates changed.

## Current-Stage Host Guidance

The current-stage deployment target for this repository is Cloudflare Pages preview deploys wired in `.github/workflows/astro-ssg-deploy-contract.yml`.

Required behavior:

1. Use preview deploys for pull requests or release-candidate branches.
2. Promote the exact same validated artifact to production after approval.
3. Treat host-specific environment variables as deployment inputs that must be recorded with the artifact bundle.
4. Preserve the last known-good production artifact set so a full artifact redeploy can restore service if needed.

Cloudflare prerequisites for preview deploy:

1. GitHub Actions secret: `CLOUDFLARE_API_TOKEN`
2. GitHub Actions secret: `CLOUDFLARE_ACCOUNT_ID`
3. GitHub Actions variable: `CLOUDFLARE_PAGES_PROJECT`

Preview deployment evidence artifact:

1. `apps/astro-ssg-thin-slice/deployment-evidence.txt`
2. Uploaded as `astro-ssg-preview-evidence-${sha}` in CI

## Hard Failures

Fail the run if any of the following occur:

1. Missing required snapshot data.
2. Missing route template.
3. Build failure from Astro or Vite.
4. Missing expected output artifact.
5. Missing sitemap generation.
6. Required preview step was skipped.
7. Deployment handoff artifact (`dist/` package + required run artifacts) is missing or incomplete.
8. Required host/environment configuration for preview or production deploy is missing.
9. The production publish does not match the validated preview artifact set.

## Warning Conditions

Warnings may be emitted for non-fatal conditions only when they do not alter the generated route set or the output artifact contract.

Examples:
- unexpected but non-blocking metadata fields
- validation notes that do not affect route emission
- build-time informational output that does not indicate failure

Warnings must never suppress a hard failure.

## Authority References

- `docs/system/agent-execution-contract.md`
- `docs/system/site-architecture.md`
- `docs/system/system-map.md`
- `docs/implementation/page-generation-pipeline.md`
