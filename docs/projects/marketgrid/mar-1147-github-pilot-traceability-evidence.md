# MAR-1147 Real GitHub Pilot Traceability Evidence

Date: 2026-05-25
Owner: CTO
Status: Done (local pilot evidence complete; board owns push/PR)

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
- `git ls-remote --heads origin` returned successfully (read access path works).
- `timeout 15s bash -lc 'GIT_TERMINAL_PROMPT=0 git push -u origin mar-1147-real-github-pilot-traceability'` returned `EXIT:124` (push path hangs/times out in this runtime).
- `gh` CLI is not installed (`which gh` -> not found), so PR creation via `gh` is unavailable.

## Traceability evidence captured
- Branch: `mar-1147-real-github-pilot-traceability`
- Commit: recorded via `git log -1 --pretty=fuller`
- PR: not created (blocked before remote push)
- Merge commit: n/a (blocked)

## What is complete
- Real local pilot run executed under MAR-1145/MAR-1146 rules.
- Issue-to-branch and issue-to-commit traceability evidence captured.
- Blocker is concrete and reproducible: remote write/PR path is unavailable from this runtime.

## Board directive update (2026-05-25)
Board explicitly set execution policy for this issue:
- Paperclip may create local commits.
- Paperclip may not push.
- Paperclip may not manage remotes.
- Paperclip may not touch credentials.

As of this directive, remote delivery is intentionally out of scope for the agent and assigned to the board.

## Reopen follow-up (2026-05-25)
- Board guidance received: use env vars `GITHUB_USERNAME` and `GITHUB_PWD`.
- Runtime verification in this heartbeat:
  - `env | rg '^GITHUB_USERNAME=|^GITHUB_PWD='` returned no matches.
  - `env | rg -i 'github|gh_'` showed no injected GitHub credential vars.
- Result at that time: unblock instructions were provided in thread, but credentials were not present in process environment.

## Final local handoff package
Local evidence ready for board-managed GitHub completion:
- Branch: `mar-1147-real-github-pilot-traceability`
- Commits on branch:
  - `09c8c6e` `MAR-1147: capture real GitHub pilot traceability evidence`
  - `99b3f73` `MAR-1147: record reproducible GitHub push-path blocker evidence`
  - `caafba9` `MAR-1147: capture env-var injection mismatch from board unblock`
- Artifact: `docs/projects/marketgrid/mar-1147-github-pilot-traceability-evidence.md`

Board steps to finish GitHub side:
1. Push `mar-1147-real-github-pilot-traceability` to `origin`.
2. Open PR using `.github/PULL_REQUEST_TEMPLATE/mar-traceability.md`.
3. Merge per MAR-1145 merge rule (`Squash and merge` unless exception documented).
4. Record PR URL and merge commit SHA in issue closeout comment.
