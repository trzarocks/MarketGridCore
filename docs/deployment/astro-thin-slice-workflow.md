# Astro Thin Slice Workflow

## Purpose

Define the canonical local and CI workflow for the Astro thin slice.

## Current Stage Deployment Path

The current-stage deployment path for this repository is Cloudflare Pages preview deploys from `.github/workflows/astro-ssg-deploy-contract.yml`.

Preferred implementation order for this stage:

1. Preview deployment from pull requests or release-candidate branches.
2. Validation gate pass on the preview artifact.
3. Explicit approval to promote the same build to production.
4. Production publish from the validated artifact only.

Host-specific command in CI:

```bash
pages deploy dist --project-name=${CLOUDFLARE_PAGES_PROJECT} --branch=${GIT_BRANCH}
```

Required repository configuration for this path:

1. GitHub Actions secret: `CLOUDFLARE_API_TOKEN`
2. GitHub Actions secret: `CLOUDFLARE_ACCOUNT_ID`
3. GitHub Actions variable: `CLOUDFLARE_PAGES_PROJECT`

## Workflow Order

1. Install dependencies
2. Validate source snapshot data
3. Validate route templates
4. Build the static site
5. Preview the built site locally
6. Inspect generated output
7. Generate the sitemap
8. Confirm expected artifacts
9. Promote release-candidate deployment handoff artifact

## Canonical Commands

From `apps/astro-ssg-thin-slice`:

```bash
npm ci
npm run validate:data
npm run validate:routes
npm run build
npm run preview
npm run build:inspect
npm run generate:sitemap
```

`npm run preview` is required before promotion when either of the following is true:
- Snapshot data changed (`src/data/thin-slice.json`).
- Any route template changed under `src/pages/**`.

## Promotion Path

Approved MarketGrid work products enter the Astro app through the existing data snapshot and route templates.

The promotion path is:

1. Approved MarketGrid source artifact
2. Snapshot update in `src/data/thin-slice.json`
3. Route generation through existing Astro pages
4. Build and validation gates
5. Static output under `dist/`

Approval constraints on step 1:
- Geo/category/listing records must be in approved/published state before promotion.
- Unapproved or draft records are hard-fail inputs for deploy runs.

## Preview Deployment Flow

Preview deploys are the first-class pre-production artifact for this stage.

Required behavior:

1. Preview deploy must be created from the same source snapshot and route templates used for the build.
2. Preview deploy must run only after `validate:data`, `validate:routes`, and `build` succeed.
3. Preview deploy must expose the same route tree as production, excluding host-specific URLs and preview-only metadata.
4. Preview approval must be explicit before any production promotion.

Cloudflare evidence artifact for each required preview deploy:

1. `deployment-evidence.txt` containing `preview_url`, `preview_alias`, `sha`, and `run_id`
2. GitHub Actions artifact name: `astro-ssg-preview-evidence-${sha}`

## Production Deployment Flow

Production deploy must use the already validated release candidate artifact.

Required behavior:

1. Production deploy must consume the preview-approved build artifact, not a re-generated artifact with changed inputs.
2. Production deploy must preserve the validated `dist/` tree and sitemap output.
3. Production deploy must fail if any required artifact or validation record is missing.
4. Production deploy must not bypass route-validation or publish-state checks.

## Rollback Expectations

Rollback is artifact-based, not content-reconstruction-based.

Required behavior:

1. Keep the last known-good `dist/` artifact and sitemap bundle available for redeploy.
2. Roll back by re-publishing the last approved release candidate.
3. Do not attempt partial route rollback; rollback must restore the complete validated artifact set.
4. If preview and production diverge, treat the production publish as invalid until the source of drift is identified.

## Environment Variables

Environment-specific configuration must be explicit and must not change route authority.

Required behavior:

1. Host secrets and preview/production site identifiers may differ by environment.
2. Public build inputs must remain stable across preview and production deploys.
3. Environment variables that affect route emission, canonical URLs, or validation results must be treated as deployment inputs and recorded with the run artifacts.
4. Missing required environment variables must fail the deployment run instead of falling back to guessed defaults.

## Required Run Artifacts

Each deployment run must retain these artifacts for verification and replay:

1. Snapshot input used by the run: `src/data/thin-slice.json` (or immutable snapshot reference in CI artifact bundle).
2. Route validation output (`npm run validate:routes` stdout/stderr capture).
3. Data validation output (`npm run validate:data` stdout/stderr capture).
4. Build inspection output (`npm run build:inspect` result with expected route/artifact checks).
5. Generated sitemap artifact: `dist/sitemap.xml`.
6. Generated route manifest or route-count evidence from build inspection.
7. Final `dist/` output archive used for deployment promotion.
8. Environment manifest or deployment-variable record used for the run.
9. Preview deployment URL or host-side artifact reference when a preview deploy was created.

## Promotion Evidence Standard

Promotion evidence must prove executed commands and observed outcomes. A slice is not promotable on intent-only or checklist-only statements.

Required evidence format per gate:

1. Command evidence:
- Exact command line used.
- Working directory used for the command.
- Exit code.

2. Outcome evidence:
- Short observed result statement.
- File/path proof when applicable (for example `dist/sitemap.xml` exists).
- Route proof when applicable (for example local/preview URL response status).

3. Failure and exception evidence:
- Any failed or skipped command.
- Reason for skip/failure.
- Follow-up issue or unblock owner if promotion is blocked.

For local execution records, the minimum accepted command set is:
- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`
- `npm run build:inspect`
- `npm run generate:sitemap`

If preview is required by this contract, evidence must also include:
- preview deploy creation command/flow reference
- preview deployment URL
- preview route checks with observed status
- preview evidence artifact reference (`astro-ssg-preview-evidence-${sha}`)

Minimum retention requirement:
- Keep the above artifacts for every CI deployment run and for local runs used as release candidates.
- Retain the last known-good production artifact set until a newer production deployment is confirmed healthy.

No direct promotion path may bypass the snapshot or route-contract checks.

## Deployment Workflow (Current Approved Boundary)

Current deployment is a release-candidate handoff of a validated static artifact, not host-specific publish automation.

Deployment workflow order:

1. Execute canonical workflow (`npm ci` through `npm run generate:sitemap`).
2. Run required local preview step (`npm run preview`) when preview-required conditions are met.
3. Confirm required artifacts and hard-failure gates have passed.
4. Package `dist/` as the release-candidate deployment artifact.
5. Handoff the artifact bundle (including required run artifacts) to the downstream deploy owner/system.

This handoff is the approved deploy boundary for the current contract.

## Deployment-Readiness Checklist

### Local Completion

A slice may be considered locally complete only when all of the following are evidenced:

1. Data validation passes.
2. Route validation passes.
3. Astro build succeeds.
4. Build inspection passes.
5. Sitemap generation succeeds.
6. New routes return `200` locally.
7. Breadcrumbs are URL-faithful.
8. Sitemap includes expected routes.
9. No schema/page-type/governance expansion occurred unless explicitly scoped.

### Preview-Ready

A slice may be considered preview-ready only when all of the following are evidenced:

1. Local completion criteria are met.
2. Preview deploy is generated successfully.
3. Preview URL is documented.
4. Preview route checks pass.
5. Visual/layout smoke check is completed.

### Production-Candidate

A slice may be considered production-candidate only when all of the following are evidenced:

1. Preview-ready criteria are met.
2. Stakeholder or CEO review is complete.
3. No hard validation failures exist.
4. Exceptions are documented.
5. Rollback path is understood.
6. Production deploy command or hosting flow is documented.

## Preview Deployment Exception Handling

Missing preview deployment URL does not automatically fail local implementation when preview deployment was not in scope or infrastructure was unavailable. The completion record must still document:

1. Whether preview deployment was expected.
2. Why preview deployment was unavailable.
3. Whether local preview passed.
4. Whether production deployment is blocked until preview infrastructure exists.
5. What follow-up issue is required, if any.

If preview was required for the slice and no approved exception is documented, production-candidate status must be denied.

## Governance Boundary

Promotion evidence confirms approved inputs rendered correctly through Astro deployment and validation gates. It does not, by itself, certify upstream content validity for source evidence packets, enrichment correctness, FAQ correctness, or listing-data correctness unless those upstream validations were explicitly run and included in the slice evidence.

## Recommended Follow-Up Decision

Each completion record should end with one explicit next-step recommendation:

1. Add more page volume.
2. Add preview deployment infrastructure coverage.
3. Expand schema/page types.
4. Hold scope and improve automation/compliance only.

## Deployment Boundary

The workflow does not change MarketGrid content authority. It only defines how approved inputs become deployable static output.

## References

- `docs/deployment/astro-ssg-deployment-contract.md`
- `docs/runtime/rendering/astro-route-generation-contract.md`
- `docs/validators/astro-deployment-validation.md`
