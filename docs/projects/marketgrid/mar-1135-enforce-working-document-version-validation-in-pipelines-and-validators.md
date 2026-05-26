# MAR-1135 Enforce Working-Document Version Validation in Pipelines and Validators

Date: 2026-05-25
Owner: CTO
Status: Delivered

## Objective
Enforce deterministic working-document version validation in pipeline and validator execution paths, not only in descriptive documentation.

## Delivered Changes
1. Pipeline verifier now enforces working-document registry version metadata before packet checks:
- `docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`
- Added `CHECK0` to validate root and per-document required version fields in `docs/projects/marketgrid/working-document-registry.json`.

2. Pipeline verifier now enforces packet-level version metadata as part of bounded validation:
- `docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`
- Added `CHECK1B` to require `contract_version` and `artifact_revision` across target packet sets.

3. Pipeline implementation doc verification now includes explicit registry version checks:
- `docs/implementation/incremental-build-pipeline.md`
- Added `jq` verification commands for required root and per-document working-document version fields.

4. Validator-facing enrichment checklist now requires version metadata and revision discipline:
- `docs/enrichment/restaurant-listing-enrichment-contract.md`
- Added checklist gates for required `contract_version` and `artifact_revision`, including revision increment on payload changes.

5. Working-document authority and registry were updated to include validator-facing enrichment contract consumption:
- `docs/system/working-document-versioning.md`
- `docs/projects/marketgrid/working-document-registry.json`
- Added `docs/enrichment/restaurant-listing-enrichment-contract.md` as a downstream consumer and tracked registry entry metadata under this issue.

## Bounded Verification
```bash
bash docs/projects/marketgrid/scripts/verify-geohub-adoption.sh

jq -e '.standard_version and .schema_version and .artifact_revision and .updated_at and .authority and .documents' \
  docs/projects/marketgrid/working-document-registry.json >/dev/null

jq -e '
  .documents
  | to_entries
  | all(
      .value.path
      and .value.standard_version
      and .value.schema_version
      and .value.artifact_revision
      and .value.upgrade_state
      and .value.promotion_state
      and .value.owner_role
      and .value.last_issue
      and .value.updated_at
    )
' docs/projects/marketgrid/working-document-registry.json >/dev/null
```

## Stop/Go
- `GO`
