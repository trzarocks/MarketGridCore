# MAR-1147 Real GitHub Pilot Traceability Evidence

Date: 2026-05-25
Owner: CTO
Status: In Progress (blocked on GitHub auth/tooling)

## Objective
Execute the MAR-1146 pilot workflow as a real issue-scoped Git/GitHub run and capture verifiable traceability evidence.

## Pilot execution log
1. Repository boundary check
- Command: `git rev-parse --is-inside-work-tree`
- Result: `true`
- Remote detected: `origin https://github.com/trzarocks/MarketGridCore`

2. Baseline artifact checks (from MAR-1146)
- `.github/workflows/baseline-ci.yml` present
- `.github/ISSUE_TEMPLATE/pilot-workflow.md` present
- `.github/PULL_REQUEST_TEMPLATE/mar-traceability.md` present

3. Pilot branch creation
- Branch: `mar-1147-real-github-pilot-traceability`

4. Atomic issue-scoped change for pilot evidence
- File added: `docs/projects/marketgrid/mar-1147-github-pilot-traceability-evidence.md`
- Commit subject format: `MAR-1147: ...`
- Commit body traceability line: `Issue: MAR-1147`

5. Remote delivery attempt
- Attempted to push pilot branch to origin.
- Blocked by missing GitHub authentication in current runtime (no `gh` CLI; no configured git credential/token).

## Traceability evidence captured
- Branch: `mar-1147-real-github-pilot-traceability`
- Commit: recorded via `git log -1 --pretty=fuller`
- PR: not created (blocked before remote push)
- Merge commit: n/a (blocked)

## What is complete
- Real local pilot run executed under MAR-1145/MAR-1146 rules.
- Issue-to-branch and issue-to-commit traceability evidence captured.
- Blocker is concrete and reproducible: GitHub auth/tooling not available in this environment.

## Unblock action
Provide one of:
1. GitHub token/credential for push access to `https://github.com/trzarocks/MarketGridCore`, or
2. Runtime with authenticated `gh` CLI configured for the target repository.

Once provided, remaining steps are: push branch, open PR with `mar-traceability` template, and record PR URL + merge evidence.
