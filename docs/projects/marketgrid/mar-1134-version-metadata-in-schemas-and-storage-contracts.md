# MAR-1134 Version Metadata in Schemas and Storage Contracts

Date: 2026-05-24
Owner: CTO
Status: Delivered

## Objective
Implement explicit version metadata in schema payload contracts and persisted storage contracts.

## Delivered Changes
1. Packet envelope schema now requires version metadata:
- `docs/implementation/incremental-build-pipeline.md`
- Added required fields: `contract_version`, `artifact_revision`

2. Enrichment payload schema now requires version metadata:
- `docs/enrichment/restaurant-listing-enrichment-contract.md`
- Added required fields: `contract_version`, `artifact_revision`

3. Working-document storage registry now carries schema version metadata:
- `docs/projects/marketgrid/working-document-registry.json`
- Added root and per-document field: `schema_version`

4. Working-document versioning authority now requires schema metadata fields:
- `docs/system/working-document-versioning.md`
- Added `schema_version` to canonical and required registry fields

5. Absent-metadata behavior is now explicit and deterministic:
- `docs/implementation/incremental-build-pipeline.md`
- `docs/enrichment/restaurant-listing-enrichment-contract.md`
- `docs/system/working-document-versioning.md`
- Added rules: missing required version metadata is invalid and consumers must not infer missing values

6. Existing packet storage artifacts normalized to include version metadata:
- `docs/projects/marketgrid/packets/**/*.packet.json`
- Added `contract_version: "v1.1"` and `artifact_revision: 1` where missing

7. Registry `last_issue` provenance updated for artifacts changed by this issue:
- `docs/projects/marketgrid/working-document-registry.json`
- Updated `last_issue` to `MAR-1134` for touched artifact entries

## Bounded Verification
```bash
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

jq -e '
  .documents["implementation.incremental-build-pipeline"].last_issue == "MAR-1134"
  and .documents["system.working-document-versioning"].last_issue == "MAR-1134"
' docs/projects/marketgrid/working-document-registry.json >/dev/null

for f in $(rg --files docs/projects/marketgrid/packets | rg '\\.packet\\.json$'); do
  jq -e 'has("contract_version") and has("artifact_revision")' "$f" >/dev/null
 done
```

## Stop/Go
- `GO`
