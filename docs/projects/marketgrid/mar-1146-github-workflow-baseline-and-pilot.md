# MAR-1146 GitHub Workflow Baseline and Pilot

Date: 2026-05-25
Owner: CTO
Status: Delivered

## Objective
Add the minimal GitHub workflow baseline that hardens MAR-1145 and define a pilot issue path with enforceable traceability checks.

## Delivered baseline
1. GitHub Actions workflow: `.github/workflows/baseline-ci.yml`
- Runs on pull requests and manual dispatch.
- Verifies required baseline paths exist.
- Lints markdown across repository.
- Fails if docs introduce absolute local filesystem links (`/var/home`, `/home/trza`) to prevent non-portable references.

2. Issue template: `.github/ISSUE_TEMPLATE/pilot-workflow.md`
- Standardizes pilot issue setup with branch, PR requirement, artifact path, and acceptance checklist.

3. PR template: `.github/PULL_REQUEST_TEMPLATE/mar-traceability.md`
- Enforces MAR-1145 traceability and verification checklist at review time.

## Pilot run definition
Pilot issue should use this template contract:
- Create issue using `Pilot workflow issue` template.
- Open branch using `mar-<issue-number>-<short-kebab-scope>`.
- Deliver one atomic change with commit message format `MAR-<number>: <summary>` and body `Issue: MAR-<number>`.
- Open PR using `mar-traceability` template and satisfy all checkboxes.
- Merge with `Squash and merge` unless documented exception.

## Dependency and mode alignment
- Aligns with MAR-1145 `Bootstrap Mode` and `Repo-Operable Mode` split.
- Keeps controls minimal and non-invasive until full branch protections are managed at repository settings level.

## Verification evidence
Executed local checks:
- `test -f .github/workflows/baseline-ci.yml`
- `test -f .github/ISSUE_TEMPLATE/pilot-workflow.md`
- `test -f .github/PULL_REQUEST_TEMPLATE/mar-traceability.md`
- `rg -n "MAR-1145 traceability checklist|Pilot workflow issue|Baseline CI" -S .github docs/projects/marketgrid/mar-1146-github-workflow-baseline-and-pilot.md`

Result: PASS

## Final disposition
- `GO`: Minimal GitHub workflow baseline is present and pilot issue flow is defined for immediate use.
