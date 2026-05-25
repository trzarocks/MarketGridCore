# MAR-1143 Inventory MarketGrid Repo Boundaries and Git Failure Modes

Date: 2026-05-25
Owner: CTO
Status: Delivered
Scope: Technical boundary inventory and failure-mode diagnostics only

## Objective
Inventory the effective repository boundaries for the assigned MarketGrid workspace and document concrete Git failure modes that affect execution portability, verification, and delivery.

## Boundary Inventory (Observed)

### 1) Assigned workspace path
- `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/marketgrid-core-systems`

### 2) Parent company workspace root
- `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9`

### 3) Repository discovery result in assigned workspace
- Running `git rev-parse --show-toplevel` from the assigned workspace fails with:
  - `fatal: not a git repository (or any parent up to mount point /var)`
  - `Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).`

### 4) Nearby Git repository visibility
- `find .. -maxdepth 3 -name .git -type d` only surfaced:
  - `../payload-test/.git`
- No `.git` directory was discovered for `marketgrid-core-systems` within the inspected local parent window.

## Effective Technical Boundary Model
1. `marketgrid-core-systems` currently behaves as a **content/work-product directory**, not a locally initialized Git checkout.
2. Git operations in this directory are boundary-sensitive and fail before reaching any potential external repository due to filesystem discovery limits.
3. Delivery portability should continue relying on **repo-local relative artifact paths inside this workspace tree** (as established in MAR-1117/MAR-1119), not assumptions about active local Git metadata.

## Git Failure Modes and Engineering Impact

### FM-1: Not-a-repository hard failure
Trigger:
```bash
git status
git rev-parse --show-toplevel
```
Observed behavior:
- Immediate fatal error: not a Git repository.
Impact:
- Cannot use branch/commit history as runtime evidence from this workspace.
- Any workflow step that assumes local `git` context will fail.

### FM-2: Filesystem boundary discovery stop
Trigger:
```bash
git rev-parse --show-toplevel
```
Observed behavior:
- Discovery stops at mount boundary with `GIT_DISCOVERY_ACROSS_FILESYSTEM not set`.
Impact:
- Even if a repository exists outside the mount/discovery boundary, automatic upward discovery is blocked.
- Tooling that expects parent traversal to locate repo root is non-portable.

### FM-3: False confidence from sibling repos
Trigger:
```bash
find .. -maxdepth 3 -name .git -type d
```
Observed behavior:
- Sibling repository (`payload-test`) exists, but is unrelated to MarketGrid scope.
Impact:
- Running Git commands from a wrong sibling path can produce misleading success while validating the wrong codebase.

### FM-4: Absolute-path coupling risk
Trigger condition:
- Scripts/docs reference machine-specific absolute paths without confirming active repo root.
Impact:
- Reproducibility degrades across agents/workspaces.
- Verification can pass on one machine layout and fail on another.

## Guardrail Checks (Minimal, Repeatable)
Run these before any Git-dependent step:

```bash
pwd
realpath .

# 1) Confirm Git root availability for current working directory
if git rev-parse --show-toplevel >/tmp/mg_git_root 2>/tmp/mg_git_err; then
  cat /tmp/mg_git_root
else
  cat /tmp/mg_git_err
fi

# 2) Detect accidental sibling-repo execution risk
find .. -maxdepth 3 -name .git -type d | sort
```

Decision rule:
1. If `git rev-parse --show-toplevel` fails, treat this workspace as non-git-bound for that heartbeat.
2. Use file-based evidence in `docs/projects/marketgrid/` and `docs/implementation/` as canonical delivery artifacts.
3. Do not assert commit/branch evidence unless Git root is explicitly resolved and recorded for the current execution context.

## Alignment with Existing MarketGrid Operating Model
- Extends MAR-1117/MAR-1119 portability direction: repo-local paths and bounded verification remain primary.
- Introduces no new systems and no schema changes.
- Keeps execution deterministic by making Git boundary detection explicit before proof/verification steps.

## Final Disposition
- `GO`: use this boundary/failure-mode inventory as preflight input for future Git-dependent MarketGrid tasks.
