# MAR-1133 Working-Document Versioning Authority and Registry Contract

Date: 2026-05-24
Owner: CTO
Status: Delivered

## Objective
Define a single working-document versioning authority and a deterministic registry contract for repo-local execution.

## Delivered Artifacts
1. Versioning authority document:
- `docs/system/working-document-versioning.md`

2. Canonical registry contract file:
- `docs/projects/marketgrid/working-document-registry.json`

## Contract Summary
1. Authority order is explicit and deterministic:
- authority document
- registry file
- issue-specific delivery notes

2. Registry path is fixed:
- `docs/projects/marketgrid/working-document-registry.json`

3. Registry schema and required per-document fields are defined and bounded around `standard_version` and `artifact_revision`.

4. Versioning behavior is explicit:
- standard/artifact bump rules
- supersession handling
- single-active-entry rule per document id

## Bounded Verification
```bash
test -f docs/system/working-document-versioning.md
test -f docs/projects/marketgrid/working-document-registry.json

jq -e '.standard_version and .artifact_revision and .updated_at and .authority and .documents' \
  docs/projects/marketgrid/working-document-registry.json >/dev/null

jq -e '
  .documents
  | to_entries
  | all(
      .value.path
      and .value.standard_version
      and .value.artifact_revision
      and .value.upgrade_state
      and .value.promotion_state
      and .value.owner_role
      and .value.last_issue
      and .value.updated_at
    )
' docs/projects/marketgrid/working-document-registry.json >/dev/null

rg -n "Authority Order|Registry Contract|Versioning Rules|Execution Gate|Compatibility Window|Promotion and Change Rules" -S \
  docs/system/working-document-versioning.md
```

## Stop/Go
- `GO`

The working-document versioning authority and registry contract are now explicitly defined, repo-local, and verifiable.
