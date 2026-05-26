# Astro Promotion Evidence Standard

## Purpose

Define the minimum evidence required for an Astro SSG slice to be considered complete and promotable.

This standard is reviewer-facing and self-contained. A completion report that omits required evidence is not promotion-ready.

## Evidence Packet Scope

Every Astro slice evidence packet must identify:

- Issue ID and slice name.
- Branch and commit SHA evaluated.
- Snapshot input reference (for example `apps/astro-ssg-thin-slice/src/data/thin-slice.json` plus commit SHA).
- Route-template files changed for this slice.
- Changed file list for the full slice.

## Minimum Required Evidence

A slice is only complete when all of the following evidence exists.

1. Added route evidence:
- Added state/geo/category/listing routes (full route paths).
- Route type coverage summary (how many geo routes, category routes, listing routes were added or changed).

2. Route volume evidence:
- Total generated route count from `npm run build:inspect` (or equivalent route-manifest output).
- Delta versus prior baseline when available.

3. Changed-file evidence:
- Canonical changed-file list for the slice.
- Explicit callout of route template changes under `src/pages/**` and snapshot-data changes.

4. Validation command evidence:
- Exact command line run.
- Working directory.
- Exit code.
- Observed outcome summary.

Minimum accepted validation/build command set:

- `npm run validate:data`
- `npm run validate:routes`
- `npm run build`
- `npm run build:inspect`
- `npm run generate:sitemap`

If preview-required conditions apply, include preview flow evidence as defined below.

5. Build/inspection evidence:
- Build completion result (`npm run build`).
- Build inspection result (`npm run build:inspect`) including route/artifact checks.

6. Sitemap evidence:
- `dist/sitemap.xml` generation success.
- Inclusion confirmation for expected new routes.

7. Breadcrumb evidence:
- Verification that breadcrumb chains are URL-faithful.
- At least one route-level proof for each new page type touched.

8. Local preview evidence:
- Local preview verification result for newly added routes.
- Observed route status (for example `200`) for sampled new routes.

9. Preview deployment evidence when available:
- Preview deploy creation command/flow reference.
- Preview deployment URL.
- Preview route checks with observed status.

10. Exception/failure evidence:
- Any failed or skipped command.
- Reason for skip/failure.
- Unblock owner and follow-up issue when promotion is blocked.

## Preview-Required Conditions

`npm run preview` and preview deployment evidence are required before promotion when either of these is true:

- Snapshot data changed (`src/data/thin-slice.json`).
- Route templates changed under `src/pages/**`.

## Local Completion and Promotion Truth Rule

A slice is not promotable on checklist-only assertions. Evidence must include executed command proof and observed outcomes.

Use this rule:

- No command evidence: gate fails.
- No outcome evidence: gate fails.
- Missing required artifact evidence: gate fails.
- Missing required preview evidence without approved exception: production-candidate gate fails.

## Preview Deployment Exception Handling Standard

Missing preview URL does not automatically fail local implementation when preview infrastructure was not in scope or unavailable. The evidence packet must still include:

- Whether preview deployment was expected for this slice.
- Why preview deployment was unavailable.
- Whether local preview passed.
- Whether production deployment is blocked until preview infrastructure exists.
- Follow-up issue ID and named owner if additional infrastructure work is required.

If preview was required and no approved exception is documented, deny production-candidate status.

## Readiness Gate Mapping

Promotion evidence must support all three readiness gates:

1. Local Completion:
- All required local validations/build/sitemap pass.
- New routes return `200` locally.
- Breadcrumb and sitemap checks pass.

2. Preview-Ready:
- Local completion is satisfied.
- Preview deploy is generated.
- Preview URL documented.
- Preview route checks pass.

3. Production-Candidate:
- Preview-ready is satisfied (or approved exception recorded).
- No unresolved hard validation failures.
- Exceptions documented.
- Rollback path identified.
- Production deploy flow documented.

## Required Final Decision

Each completion packet must end with exactly one recommended next step:

- Add more page volume.
- Add preview deployment infrastructure coverage.
- Expand schema/page types.
- Hold scope and improve automation/compliance only.

## Governance Boundary

Promotion evidence confirms deployment-path validity for approved inputs through Astro validation/build gates. It does not, by itself, certify upstream source-content correctness unless those upstream validations are explicitly included.

## References

- `docs/deployment/astro-thin-slice-workflow.md`
- `docs/deployment/astro-ssg-deployment-contract.md`
- `docs/validators/astro-deployment-validation.md`
