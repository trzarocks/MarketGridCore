# Working-Document Versioning

Date: 2026-05-25
Owner: CTO
Status: Active

## Purpose
Define the canonical standard for versioning working documents in the MarketGrid repo and the registry contract that consumers must use to resolve authority, compatibility, and promotion state.

## Scope
In scope artifact classes:
1. Geohub research deliverables.
2. Enrichment and validation artifacts.
3. Implementation-facing packet and validator artifacts.
4. Repo-local working documents that are consumed by issue execution.

Out of scope:
1. Runtime implementation changes.
2. Validator engine changes.
3. Broad repository migration work.

## Canonical Fields
Consumers of this standard must use these fields:
1. `standard_version`: the version of this working-document standard.
2. `schema_version`: the schema/storage contract version consumed by tooling.
3. `artifact_revision`: the revision of an individual artifact or registry entry.
4. `upgrade_state`: the compatibility state for the artifact.
5. `promotion_state`: whether the artifact is active, staged, or retired.
6. `last_issue`: the last issue key that updated the artifact.
7. `updated_at`: the last update date in `YYYY-MM-DD`.

## Standard Versioning Rules
1. `standard_version` changes only when the governing rules of this standard change.
2. `artifact_revision` increments when a document, packet contract, or registry entry changes.
3. `standard_version` and `artifact_revision` are separate counters and must not be conflated.
4. If a document changes without changing the standard, only `artifact_revision` advances.

## Compatibility Window
The current standard supports:
1. Current major standard version.
2. The immediately previous major standard version during a bounded transition window.

Compatibility states:
1. `compatible`
2. `compatible_with_upgrade`
3. `deprecated`
4. `retired`

Rules:
1. `compatible` means the artifact can be consumed without special handling.
2. `compatible_with_upgrade` means consumers may read the artifact, but a follow-up promotion is required.
3. `deprecated` means consumers should not create new dependencies on the artifact.
4. `retired` means consumers must not use the artifact for new execution.

## Promotion and Change Rules
1. Promote a document only after its registry entry is updated.
2. Do not promote a document that lacks a stable `artifact_revision`.
3. Use `compatible_with_upgrade` for transitional artifacts that still meet execution requirements.
4. Move deprecated documents to `retired` only after downstream consumers have been updated.

## Downstream Consumers
These docs/contracts must consume this authority:
1. `docs/projects/marketgrid/working-document-registry.json`
2. `docs/implementation/incremental-build-pipeline.md`
3. `docs/enrichment/restaurant-listing-enrichment-contract.md`
4. `docs/runtime/rendering/listing-renderer-governance.md`
5. Any new issue delivery note that records working-document versioning changes.

## Registry Contract
Canonical registry path:
- `docs/projects/marketgrid/working-document-registry.json`

Required registry root fields:
1. `standard_version`
2. `schema_version`
3. `artifact_revision`
4. `authority`
5. `updated_at`
6. `documents`

Required per-document fields:
1. `path`
2. `standard_version`
3. `schema_version`
4. `artifact_revision`
5. `upgrade_state`
6. `promotion_state`
7. `owner_role`
8. `last_issue`
9. `updated_at`
10. `supersedes` when applicable

Absent metadata rule:
1. A registry root missing any required root version field (`standard_version`, `schema_version`, `artifact_revision`) is invalid and must not be consumed.
2. A document entry missing any required per-document version field is invalid and must not be consumed.
3. Consumers must not infer missing version metadata from neighboring entries, issue notes, or prior revisions.

## Authority Order
When resolving conflicts, consume authority in this order:
1. This document.
2. The registry file.
3. Issue-specific delivery notes.

Rules:
1. This document defines the standard.
2. The registry records the current authoritative instances.
3. Delivery notes may summarize changes but cannot override the standard or registry.

## Execution Gate
Before closing an issue that changes working-document authority:
1. Update this standard if the governing rule changed.
2. Update the registry entry and bump `artifact_revision`.
3. Confirm `standard_version`, `schema_version`, and `artifact_revision` fields are present.
4. Verify downstream consumers named above still point to this authority.
