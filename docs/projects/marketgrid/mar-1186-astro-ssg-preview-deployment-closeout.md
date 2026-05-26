# MAR-1186 Astro SSG Preview Deployment Closeout

## Scope

Close-out pass for Cloudflare Pages preview deployment workflow documentation and preview-ready evidence clarity.

## Working Directory

- `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/marketgrid-core-systems`

## Selected Preview Host

- Cloudflare Pages (existing workflow: `.github/workflows/astro-ssg-deploy-contract.yml`)

## Changed Files

1. `docs/deployment/astro-thin-slice-workflow.md`
2. `docs/deployment/astro-ssg-deployment-contract.md`
3. `docs/deployment/astro-deployment-readiness-checklist.md`
4. `docs/projects/marketgrid/mar-1186-astro-ssg-preview-deployment-closeout.md`

## Commands Run

| Command | Exit Code | Outcome |
| --- | --- | --- |
| `rg --files .github workflows docs apps/astro-ssg-thin-slice` | `0` | Located workflow/docs surfaces (non-fatal missing `workflows/` path argument). |
| `rg -n "Cloudflare|preview|deploy|astro-ssg" -S .github docs apps/astro-ssg-thin-slice` | `0` | Confirmed Cloudflare workflow exists and identified canonical docs for close-out. |
| `sed -n '1,240p' .github/workflows/astro-ssg-deploy-contract.yml` | `0` | Verified implemented preview deploy command and required Cloudflare secrets/vars. |
| `sed -n '1,280p' docs/deployment/astro-thin-slice-workflow.md` | `0` | Verified canonical workflow content to update. |
| `sed -n '1,280p' docs/deployment/astro-ssg-deployment-contract.md` | `0` | Verified canonical contract content to update. |
| `sed -n '1,240p' docs/deployment/astro-deployment-readiness-checklist.md` | `0` | Verified checklist surface to add preview-ready evidence note. |

## Cloudflare Preview Deployment Command

From CI (Wrangler action command):

```bash
pages deploy dist --project-name=${CLOUDFLARE_PAGES_PROJECT} --branch=${GIT_BRANCH}
```

## Required Environment Variables / Secrets

1. `CLOUDFLARE_API_TOKEN` (GitHub Actions secret)
2. `CLOUDFLARE_ACCOUNT_ID` (GitHub Actions secret)
3. `CLOUDFLARE_PAGES_PROJECT` (GitHub Actions repository variable)

## Preview URL Status

- Documented preview URL from a successful run: unavailable in this heartbeat.
- Concrete prerequisite blocker: repository-level Cloudflare deployment prerequisites must be provisioned and validated in GitHub Actions for the target repo/environment (owner: CTO/repo admin with Cloudflare access).

## Preview-Ready Evidence Note

- Preview-required decision: derived from workflow rule when `src/data/thin-slice.json` or `src/pages/**` changes in a pull request.
- Evidence artifact location: GitHub Actions artifact `astro-ssg-preview-evidence-${sha}` containing `deployment-evidence.txt`.
- Smoke-check status: workflow captures preview URL/alias; route/visual smoke checks remain required evidence items and are recorded per run in the completion report/checklist.

## Disposition

- CTO close-out documentation pass complete for MAR-1186 scope.
