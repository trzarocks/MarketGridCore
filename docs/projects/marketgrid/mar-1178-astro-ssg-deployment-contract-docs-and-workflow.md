# MAR-1178 Astro SSG Deployment Contract Docs and Workflow

## Objective

Formalize a deterministic deployment contract for the Astro SSG thin-slice implementation and wire it into CI for repeatable enforcement.

## Delivered Artifacts

1. Deployment contract doc:
- `docs/implementation/astro-ssg-deployment-contract.md`

2. CI workflow:
- `.github/workflows/astro-ssg-deploy-contract.yml`

## Contract Summary

- Contract is constrained to `apps/astro-ssg-thin-slice`.
- Defines required inputs, ordered pipeline commands, expected build artifacts, and explicit failure conditions.
- CI workflow enforces the same sequence with fail-fast behavior.

## Verification Commands

```bash
cd apps/astro-ssg-thin-slice
npm run validate:data
npm run validate:routes
npm run build
npm run build:inspect
npm run generate:sitemap
test -f dist/sitemap.xml
```

## Outcome

Astro SSG deployment expectations are now explicit, versionable, and machine-enforced in pull requests affecting the Astro thin-slice app.
