# MAR-1141 Implement MAR-1137 Operating-Model Corrections

Date: 2026-05-25
Owner: CTO
Status: Delivered
Scope: Operating-model correction implementation only (no new systems)

## Objective
Implement the MAR-1137/MAR-1139 operating-model correction set as executable repo-local enforcement, with bounded verification.

## Implemented in This Slice
1. Added canonical packet path coherence enforcement to `docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`.
2. Updated `docs/implementation/incremental-build-pipeline.md` runtime contract to require packet field/path coherence for `issue`, `batch_id`, and `stage`.

## Correction Mapping
1. Correction: Promote packet evidence to a required operating primitive.
- Implementation: `CHECK1C` now enforces that each packet's `.issue`, `.batch_id`, and `.stage` match its canonical path placement and filename convention.

2. Correction: Freeze deterministic routing and reduce drift.
- Implementation impact: path/field mismatch is now a hard verification failure, preventing ambiguous packet placement from being treated as valid execution evidence.

## Bounded Verification
```bash
bash docs/projects/marketgrid/scripts/verify-geohub-adoption.sh
```

Expected enforcement signals include:
- `CHECK1C_OK` on compliant corpus
- `CHECK1C_*_MISMATCH` on drift/non-canonical evidence

## Final Disposition
- `GO`: MAR-1137 operating-model correction is implemented in runtime verification and implementation contract docs for MarketGrid packet evidence handling.
