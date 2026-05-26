# Astro Deployment Readiness Checklist

Use this checklist to classify an Astro slice as Local Completion, Preview-Ready, or Production-Candidate.

A status cannot be granted without command-and-outcome evidence.

## Required Inputs Before Gating

- Slice metadata completed (issue, branch, commit, owner, date).
- Route and changed-file summary completed.
- Command table completed with working directory, exit code, and observed outcomes.
- Artifact evidence captured (including `dist/sitemap.xml` and route-count evidence).

## Gate 1: Local Completion

Mark Local Completion only when all checks below are true.

- [ ] `npm run validate:data` passed.
- [ ] `npm run validate:routes` passed.
- [ ] `npm run build` passed.
- [ ] `npm run build:inspect` passed.
- [ ] `npm run generate:sitemap` passed.
- [ ] Generated route count recorded.
- [ ] Added geo/category/listing routes documented.
- [ ] Changed files documented.
- [ ] New routes return `200` locally.
- [ ] Breadcrumb checks are URL-faithful for affected route types.
- [ ] `dist/sitemap.xml` exists.
- [ ] Sitemap includes expected newly added routes.
- [ ] No unsanctioned schema/page-type/governance expansion occurred.

Fail conditions:

- Any required command missing or non-zero exit.
- Missing route-count evidence.
- Missing sitemap inclusion confirmation.
- Missing breadcrumb verification evidence.

## Gate 2: Preview-Ready

Mark Preview-Ready only when Local Completion is true and all checks below are true.

- [ ] Preview requirement decision is documented.
- [ ] Preview-required decision references the contract rule (snapshot and/or route-template change).
- [ ] If preview is required, preview deployment was generated.
- [ ] Preview URL is documented.
- [ ] Preview route checks passed for representative new routes.
- [ ] Visual/layout smoke check completed.
- [ ] Preview evidence artifact location is documented (`astro-ssg-preview-evidence-${sha}`).

Fail conditions:

- Preview required but URL/check evidence missing.
- Preview route checks show unresolved errors.

## Gate 3: Production-Candidate

Mark Production-Candidate only when Preview-Ready is true or an approved preview exception exists, and all checks below are true.

- [ ] Stakeholder/CEO review complete.
- [ ] No unresolved hard validation failures.
- [ ] Exceptions documented with owners/actions.
- [ ] Rollback path for last known-good artifact identified.
- [ ] Production deploy command/hosting flow documented.
- [ ] Evidence packet includes required run artifacts.

Fail conditions:

- Missing approval/review record.
- Missing rollback path.
- Missing production deploy flow details.

## Preview Deployment Exception Checklist

Use only when preview URL is unavailable.

- [ ] Statement of whether preview deployment was expected.
- [ ] Reason preview was unavailable.
- [ ] Local preview result documented.
- [ ] Decision on whether production is blocked until preview infrastructure exists.
- [ ] Concrete prerequisite blocker is named (owner + required secret/variable or host setup action).
- [ ] Follow-up issue created with owner.
- [ ] Exception approval reference recorded.

Rule:

- If preview was required and no approved exception exists, Production-Candidate must be denied.

## Required Run Artifacts Checklist

- [ ] Snapshot input reference (`src/data/thin-slice.json` or immutable snapshot artifact).
- [ ] Route validation output capture.
- [ ] Data validation output capture.
- [ ] Build inspection output capture.
- [ ] Generated sitemap artifact (`dist/sitemap.xml`).
- [ ] Route-count/manifest evidence.
- [ ] Final `dist/` deployment archive.
- [ ] Environment/deployment-variable manifest.
- [ ] Preview deployment URL or host artifact reference (when preview deploy exists).

## Governance and Boundary Checks

- [ ] Evidence only claims Astro deployment-path validity.
- [ ] Upstream source-content validity is claimed only where explicitly validated.

## Required Final Recommendation

Each checklist run must end with exactly one recommendation:

- [ ] Add more page volume.
- [ ] Add preview deployment infrastructure coverage.
- [ ] Expand schema/page types.
- [ ] Hold scope and improve automation/compliance only.
