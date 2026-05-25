# MAR-1136 Prove Bounded Upgrade Path on Geohub and Enrichment Samples

Date: 2026-05-25
Owner: CTO
Status: Delivered

## Objective
Provide an executable, bounded proof that the current version window accepts intended geohub/enrichment sample contracts and rejects out-of-window versions.

## Delivered Changes
1. Added a deterministic proof script:
- `docs/projects/marketgrid/scripts/prove-bounded-upgrade-path.sh`
- Verifies `v1.0` and `v1.1` are accepted for both geohub packet and enrichment sample artifacts.
- Verifies out-of-window versions (`v0.9`, `v2.0`) are rejected.
- Re-checks active geohub packet corpus for required metadata (`contract_version`, `artifact_revision`).

2. Added bounded proof fixtures:
- `docs/projects/marketgrid/samples/MAR-1136/geohub-packet-v1.0.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/geohub-packet-v1.1.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/geohub-packet-v0.9.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/geohub-packet-v2.0.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/enrichment-v1.0.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/enrichment-v1.1.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/enrichment-v0.9.sample.json`
- `docs/projects/marketgrid/samples/MAR-1136/enrichment-v2.0.sample.json`

## Bounded Verification
```bash
bash docs/projects/marketgrid/scripts/prove-bounded-upgrade-path.sh
```

Expected terminal sentinel:
- `BOUND_UPGRADE_PROOF_OK`

## Stop/Go
- `GO`
