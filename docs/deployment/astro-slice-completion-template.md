# Astro Slice Completion Template

Use this template to report completion for any Astro thin-slice promotion candidate.

## Slice Metadata

- Issue:
- Branch/commit:
- Snapshot input:
- Scope summary:
- Date:
- Owner:

## Command and Outcome Evidence

List each command exactly as executed, including working directory and exit code.

| Command | Working Directory | Exit Code | Observed Outcome |
| --- | --- | --- | --- |
| `npm run validate:data` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run validate:routes` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run build` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run build:inspect` | `apps/astro-ssg-thin-slice` |  |  |
| `npm run generate:sitemap` | `apps/astro-ssg-thin-slice` |  |  |

## Artifact Evidence

- `dist/index.html`:
- `dist/sitemap.xml`:
- Route/count evidence:
- Dist archive reference:
- Environment manifest reference:

## Deployment-Readiness Checklist

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

Preview URL:

Preview route check evidence:

### Production-Candidate

- [ ] Preview-ready criteria are met.
- [ ] Stakeholder or CEO review is complete.
- [ ] No hard validation failures exist.
- [ ] Exceptions are documented.
- [ ] Rollback path is understood.
- [ ] Production deploy command or hosting flow is documented.

Production deploy command/hosting flow:

Rollback path:

## Preview Deployment Exception Handling

Complete this section when preview deployment URL is unavailable.

- Was preview deployment expected for this slice?
- Why was preview unavailable?
- Did local preview pass?
- Is production blocked until preview infrastructure exists?
- Follow-up issue ID and owner:

## Governance Boundary Confirmation

- [ ] This report confirms Astro promotion evidence only.
- [ ] Upstream content/evidence/enrichment validity is only claimed where explicitly validated in this report.

## Recommended Follow-Up Decision

Select exactly one:

- [ ] 1. Add more page volume.
- [ ] 2. Add preview deployment infrastructure coverage.
- [ ] 3. Expand schema/page types.
- [ ] 4. Hold scope and improve automation/compliance only.

## Notes and Exceptions

- Exception 1:
- Exception 2:
