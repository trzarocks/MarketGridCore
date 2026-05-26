# MAR-1187 Cloudflare Pages Preview Credential Provisioning

## Scope

Provision repository-level Cloudflare Pages preview credentials and capture the first live Astro preview URL for `apps/astro-ssg-thin-slice`.

## Authority Packet Used

- Parent packet: `MAR-1185` comment `4e94293c-39d6-4db6-90ff-8e280ace61d2`
- Mode: packet + task docs only

## Execution Summary

This heartbeat verified the deployment workflow contract and attempted credential provisioning from the available execution environment.

Result: blocked by missing admin credentials/access in this runtime.

## Verification Performed

1. Confirmed Cloudflare preview deployment workflow exists and is wired:
- File: `.github/workflows/astro-ssg-deploy-contract.yml`
- Workflow requires:
  - `secrets.CLOUDFLARE_API_TOKEN`
  - `secrets.CLOUDFLARE_ACCOUNT_ID`
  - `vars.CLOUDFLARE_PAGES_PROJECT`
- Workflow captures:
  - `steps.cf_pages.outputs.deployment-url`
  - `steps.cf_pages.outputs.pages-deployment-alias-url`
  - Artifact `astro-ssg-preview-evidence-${sha}` with `deployment-evidence.txt`

2. Confirmed local runtime access limits:
- `gh` CLI unavailable in runtime (`gh: command not found`)
- No environment credentials present for:
  - `GITHUB_TOKEN` / `GH_TOKEN`
  - `CLOUDFLARE_API_TOKEN`
  - `CLOUDFLARE_ACCOUNT_ID`
  - `CLOUDFLARE_PAGES_PROJECT`

## Blocker (First-Class)

- Blocker: repository/admin-level credentials required to configure GitHub Actions secrets/vars are not available to this assigned runtime.
- Unblock owner: CTO/repo admin with GitHub repository admin + Cloudflare account access.
- Required unblock action:
  1. Set GitHub Actions secret `CLOUDFLARE_API_TOKEN`.
  2. Set GitHub Actions secret `CLOUDFLARE_ACCOUNT_ID`.
  3. Set GitHub Actions repository variable `CLOUDFLARE_PAGES_PROJECT`.
  4. Trigger `.github/workflows/astro-ssg-deploy-contract.yml` on a qualifying PR with changes under `apps/astro-ssg-thin-slice/src/data/thin-slice.json` or `apps/astro-ssg-thin-slice/src/pages/**`.
  5. Capture and post:
     - preview URL
     - preview alias
     - artifact reference `astro-ssg-preview-evidence-${sha}`
     - route-check outcome summary

## Preview URL Status

- First live preview URL: not captured in this heartbeat due to the blocker above.

## Disposition Recommendation

- Keep this issue `blocked` until credentials are provisioned and one qualifying preview deploy run produces `deployment-evidence.txt`.
