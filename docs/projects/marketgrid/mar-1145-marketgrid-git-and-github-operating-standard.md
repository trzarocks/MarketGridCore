# MAR-1145 MarketGrid Git and GitHub Operating Standard

Date: 2026-05-25
Owner: CTO
Status: Delivered
Scope: Git/GitHub execution standards for MarketGrid contributor workflows

## 1) Purpose
Define one minimal, enforceable standard for day-to-day Git and GitHub use in MarketGrid that:
- Matches current boundary findings from [MAR-1143](/PAP/issues/MAR-1143)
- Stays valid before and after canonical-repo bootstrap in [MAR-1144](/PAP/issues/MAR-1144)
- Provides issue-to-branch/commit/PR traceability for downstream workflow baseline work in [MAR-1146](/PAP/issues/MAR-1146)

## 2) Current Boundary Reality (Policy Inputs)
- The assigned MarketGrid workspace currently operates as a work-product directory, not a resolved local Git checkout (MAR-1143).
- `MAR-1144` (canonical repo restore/bootstrap) is not complete yet; therefore GitHub-first controls must be staged, not assumed.

Operating consequence:
- This standard has two modes: `Bootstrap Mode` (canonical repo not yet confirmed) and `Repo-Operable Mode` (canonical root and remote are confirmed by MAR-1144 acceptance evidence).

## 3) Branch Naming and Lifecycle

### Branch naming
When in `Repo-Operable Mode`, branch names must be:
- `mar-<issue-number>-<short-kebab-scope>`
- Example: `mar-1145-git-github-operating-standard`

Rules:
- One issue maps to one primary branch.
- If a follow-on fix is required after merge, open a new issue and new branch.
- Do not reuse closed-issue branches for new scope.

### Branch lifecycle
1. Create branch from canonical default branch.
2. Commit only issue-scoped changes.
3. Open PR when PR is required by Section 5.
4. Merge using the approved method in Section 4.
5. Delete branch after merge.

`Bootstrap Mode` exception:
- If canonical root is not yet Git-operable, record artifacts and delivery notes in `docs/projects/marketgrid/` under the issue id, then transition to branch workflow once MAR-1144 is complete.

## 4) Commit Expectations and Merge Method

### Commit expectations
- Commits must be atomic and issue-scoped.
- Commit subject must start with issue id: `MAR-<number>: <summary>`.
- Each commit body must include traceability line: `Issue: MAR-<number>`.
- Avoid mixing unrelated cleanup with issue deliverables unless required for correctness.

### Merge method
Default merge method: `Squash and merge`.

Why:
- Keeps history readable while preserving issue-level intent.
- Matches small, issue-scoped execution slices.

Exceptions:
- Use merge commit only when preserving multiple meaningful commits is required for audit/debug value.
- Rebase-merge is optional but not default.

## 5) When PRs Are Required vs Direct Commits

### PR required
PR is mandatory when any of the following is true:
- Changes affect shared system contracts (`docs/system/*`, schema contracts, or reusable scripts).
- Changes cross more than one issue scope.
- The branch will be merged into canonical default branch.
- Work is part of pilot/rollout governance (`MAR-1146` and onward).

### Direct commit allowed
Direct commit to default branch is allowed only when all are true:
- Repository is in `Bootstrap Mode` or emergency hotfix context.
- Change is low-risk, single-file, and reversible.
- No contract/system-level authority file is modified.
- A Paperclip issue comment records why PR was skipped.

Direct-commit allowance is temporary and should be retired once branch protections are enabled in MAR-1146.

## 6) Paperclip Traceability Mapping
For each issue in `Repo-Operable Mode`, record:
- Branch: `mar-<issue-number>-...`
- Commit ids used for delivery
- PR id/link when a PR is used
- Final merge commit/squash commit id

Required placement:
- Issue closeout comment (Paperclip thread)
- Optional delivery note in `docs/projects/marketgrid/` when additional artifact context is needed

Minimum traceability rule:
- No issue may be marked `done` without at least commit evidence, or explicit `Bootstrap Mode` note explaining why commit evidence is not yet available.

## 7) Artifact Placement and Authority Boundaries

### Allowed issue-scoped artifact location
- `docs/projects/marketgrid/` (issue-specific reports, delivery notes, bounded analyses)

### Non-authoritative by default
Artifacts in `docs/projects/marketgrid/` are execution evidence, not permanent system authority, unless promoted through explicit follow-up governance.

### Authority promotion rule
To become standing authority, content must be intentionally migrated to the canonical authority paths (for example `docs/system/*` or other approved authority docs) through a separate scoped issue.

## 8) Preconditions and Dependency Gates
- `MAR-1143` provides boundary truth and failure modes.
- `MAR-1144` must complete before full branch/PR enforcement can be treated as default operating posture.
- `MAR-1146` should implement GitHub safeguards (for example templates/protections/checks) that harden this standard.

## 9) Compliance Checklist (Per Issue)
1. Issue id present in branch name or documented bootstrap exception.
2. Commit subject/body traceability present.
3. PR used when required, or direct-commit exception documented.
4. Artifacts stored in allowed issue-scoped location.
5. No accidental promotion of issue artifact to authority without explicit migration issue.

## Final Disposition
- `GO`: This standard is approved for immediate MarketGrid use in Bootstrap Mode and for normal enforcement once MAR-1144 establishes Repo-Operable Mode.
