# MAR-1179 Extend Astro Contract With Deployment and Promotion Workflow

## Objective

Extend the Astro thin-slice contract surface to explicitly include deployment and release-candidate promotion workflow, with deterministic validation and artifact handoff requirements.

## Delivered Artifacts

1. Canonical deployment contract:
- `docs/deployment/astro-ssg-deployment-contract.md`

2. Canonical deployment/promotion workflow:
- `docs/deployment/astro-thin-slice-workflow.md`

3. Validation authority for deployment gates:
- `docs/validators/astro-deployment-validation.md`

4. Route-generation contract authority used by deployment:
- `docs/runtime/rendering/astro-route-generation-contract.md`

5. CI enforcement workflow:
- `.github/workflows/astro-ssg-deploy-contract.yml`

## Contract Extensions Implemented

1. Added explicit six-phase deployment model, ending in release-candidate artifact handoff.
2. Added required run-artifact retention contract for deployment replay and verification.
3. Added promotion-path constraints requiring approved/published source records.
4. Added hard-failure conditions for missing deployment handoff artifacts and skipped required preview step.
5. Added explicit deployment boundary (validated static artifact handoff; no host publish automation).
6. Wired CI trigger coverage for both Astro app changes and deployment-contract authority doc changes.

## Verification Commands

```bash
cd apps/astro-ssg-thin-slice
npm ci
npm run validate:data
npm run validate:routes
npm run build
npm run build:inspect
npm run generate:sitemap
test -f dist/index.html
test -f dist/maryland/index.html
test -f dist/maryland/towson-md/index.html
test -f dist/maryland/towson-md/business-directory/restaurants/index.html
test -f dist/maryland/towson-md/business-directory/restaurants/banditos-bar-and-kitchen/index.html
test -f dist/sitemap.xml
```

## Outcome

Astro deployment and promotion workflow requirements are now explicit, authority-scoped, and CI-enforced as part of the thin-slice deployment contract.
