# MAR-1116 Incremental-Build Artifact Placement and Wiring Evidence

Date: 2026-05-23
Owner: CTO
Status: Delivered

## Issue
The incremental-build skill advertised `incremental-build-pipeline.md` as an available script artifact, but no file existed at the expected skill artifact location. `documentation.md` also pointed to this missing attachment.

## Correct Placement Applied
Created the canonical repo-local artifact at:

- `docs/implementation/incremental-build-pipeline.md`

Kept the provenance source in repo-local project documentation:

- `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`

## Wiring Alignment Verified
The following repo-local references resolve to real artifact files:

1. `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`
- Canonical source contract for stage and lifecycle behavior.
2. `docs/projects/marketgrid/mar-1116-incremental-build-artifact-placement-and-wiring-evidence.md`
- Placement/wiring evidence retained in-project.
3. `docs/implementation/incremental-build-pipeline.md`
- Canonical repo-local deliverable for this issue.

## Evidence Commands

```bash
find docs -maxdepth 3 -type f | sort
rg -n "incremental-build-pipeline|Source Contract|Correct Placement Applied" -S docs
```

## Result
Artifact placement and reference wiring are now consistent in shared repo-local paths.
