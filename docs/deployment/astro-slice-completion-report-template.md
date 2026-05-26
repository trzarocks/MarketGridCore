# Astro Slice Completion Report Template

Use this template for every Astro SSG slice promotion candidate. Fill all required fields.

## 1) Slice Metadata

- Issue:
- Slice name:
- Owner:
- Date (UTC):
- Branch:
- Commit SHA:
- Working tree status at run time:
- Snapshot input reference:
- Scope summary:

## 2) Route and File Change Summary

### Added or changed routes

- Geo routes:
- Category routes:
- Listing routes:
- Route-path list (all new/changed canonical paths):

### Generated route volume

- Total generated route count:
- Prior baseline route count (if known):
- Route delta:

### Changed files

- Full changed file list:
- Route-template files changed under `src/pages/**`:
- Snapshot data changed (`src/data/thin-slice.json`): yes/no

## 3) Command and Outcome Evidence

List each command exactly as executed, including working directory and exit code.

| Command | Working Directory | Exit Code | Observed Outcome |
| --- | --- | --- | --- |
| `npm run validate:data` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run validate:routes` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run build` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run build:inspect` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run generate:sitemap` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run preview` (when required) | `apps/astro-ssg-thin-slice` |  |  |

## 4) Build Inspection and Artifact Evidence

- Build inspection result summary:
- Route-manifest/route-count evidence reference:
- `dist/index.html` exists:
- `dist/sitemap.xml` exists:
- Sitemap inclusion confirmation for new routes:
- `dist/` archive reference:
- Environment/deployment-variable manifest reference:

## 5) Breadcrumb and Route Verification Evidence

### Breadcrumb verification

- Geo breadcrumb proof:
- Category breadcrumb proof:
- Listing breadcrumb proof:

### Local route checks

- Sampled route checks (path + observed status):
- Local preview verification summary:

## 6) Preview Deployment Evidence

### Preview requirement decision

- Was preview required by contract for this slice? (yes/no)
- Requirement basis (snapshot change, route-template change, both, or none):

### Preview deployment details (if available)

- Preview creation flow/command reference:
- Preview URL:
- Preview route checks (path + observed status):
- Visual/layout smoke check summary:

## 7) Deployment-Readiness Checklist

### Local Completion

- [ ] Data validation passes.
- [ ] Route validation passes.
- [ ] Astro build succeeds.
- [ ] Build inspection passes.
- [ ] Sitemap generation succeeds.
- [ ] New routes return `200` locally.
- [ ] Breadcrumbs are URL-faithful.
- [ ] Sitemap includes expected routes.
- [ ] No schema/page-type/governance expansion occurred unless explicitly scoped.

### Preview-Ready

- [ ] Local completion criteria are met.
- [ ] Preview deploy is generated successfully.
- [ ] Preview URL is documented.
- [ ] Preview route checks pass.
- [ ] Visual/layout smoke check is completed.

### Production-Candidate

- [ ] Preview-ready criteria are met or approved exception is documented.
- [ ] Stakeholder or CEO review is complete.
- [ ] No hard validation failures exist.
- [ ] Exceptions are documented.
- [ ] Rollback path is understood.
- [ ] Production deploy command or hosting flow is documented.

## 8) Preview Deployment Exception Handling (Required when preview URL is unavailable)

- Was preview deployment expected for this slice?
- Why was preview unavailable?
- Did local preview pass?
- Is production deployment blocked until preview infrastructure exists?
- Follow-up issue ID and owner:
- Approval reference for exception acceptance:

## 9) Governance Boundary Confirmation

- [ ] This report confirms Astro promotion/deployment-path evidence only.
- [ ] Upstream source-content/evidence/enrichment validity is only claimed where explicitly validated in this report.

## 10) Notes, Failures, and Exceptions

- Failure/skip record 1:
- Failure/skip record 2:
- Additional exception notes:

## 11) Required Follow-Up Decision

Select exactly one:

- [ ] 1. Add more page volume.
- [ ] 2. Add preview deployment infrastructure coverage.
- [ ] 3. Expand schema/page types.
- [ ] 4. Hold scope and improve automation/compliance only.

## 12) Final Disposition

- Current disposition: `done` | `in_review` | `blocked` | `in_progress`
- If `in_review`, reviewer and approval path:
- If `blocked`, unblock owner and action:
- If `in_progress`, live continuation path:
