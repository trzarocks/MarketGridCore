# MAR-1117 Move Incremental-Build Delivery Into Shared Repo-Local Paths

Date: 2026-05-23
Owner: CTO
Status: Delivered

## Objective
Move incremental-build delivery references from machine-specific absolute paths to shared repo-local paths so the artifact contract is portable across workspaces and agents.

## Changes Applied
1. Updated `docs/implementation/incremental-build-pipeline.md`:
- Replaced absolute-path source contract reference with repo-local source artifact reference.
- Replaced skill-side absolute-path wiring references with repo-local project docs.
- Replaced absolute-path verification command with repo-local grep verification.

2. Updated `docs/projects/marketgrid/mar-1116-incremental-build-artifact-placement-and-wiring-evidence.md`:
- Replaced absolute-path placement references with repo-local paths.
- Reframed wiring verification to reference repo-local artifacts only.
- Replaced absolute-path evidence commands with repo-local commands.

## Verification
```bash
rg -n "incremental-build|Source Contract|Paperclip Wiring|Correct Placement Applied" -S \
  docs/implementation/incremental-build-pipeline.md \
  docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md \
  docs/projects/marketgrid/mar-1116-incremental-build-artifact-placement-and-wiring-evidence.md \
  docs/projects/marketgrid/mar-1117-move-incremental-build-delivery-into-shared-repo-local-paths.md
```

## Result
Incremental-build delivery artifacts now point to shared repo-local paths for source contract, wiring evidence, and verification, removing machine-specific coupling for this delivery slice.
