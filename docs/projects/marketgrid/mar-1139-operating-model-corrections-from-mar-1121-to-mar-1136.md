# MAR-1139 Operating-Model Corrections from MAR-1121 to MAR-1136

Date: 2026-05-25
Owner: CTO
Status: Delivered
Scope: Operating-model corrections only (no new systems)

## Objective
Convert the execution evidence from `MAR-1121` through `MAR-1136` into explicit operating-model corrections that improve determinism, reduce drift, and keep technical delivery aligned with existing authority and pipeline contracts.

## Evidence Window Used
1. `docs/projects/marketgrid/mar-1121-incremental-build-pipeline-skill-integration-plan.md`
2. `docs/projects/marketgrid/mar-1122-step-1-runtime-wiring-contract.md`
3. `docs/projects/marketgrid/mar-1123-step-2-skill-doc-adaptation.md`
4. `docs/projects/marketgrid/mar-1124-step-3-execution-evidence-template.md`
5. `docs/projects/marketgrid/mar-1125-step-4-minimal-verification-wiring.md`
6. `docs/projects/marketgrid/mar-1129-hyperagent-geohub-adoption-report.md`
7. `docs/projects/marketgrid/mar-1130-geohub-adoption-gap-closure-and-bounded-verification.md`
8. `docs/projects/marketgrid/mar-1131-towson-md-geohub-build-test-difference-report.md`
9. `docs/projects/marketgrid/mar-1133-working-document-versioning-authority-and-registry-contract.md`
10. `docs/projects/marketgrid/mar-1134-version-metadata-in-schemas-and-storage-contracts.md`
11. `docs/projects/marketgrid/mar-1135-enforce-working-document-version-validation-in-pipelines-and-validators.md`
12. `docs/projects/marketgrid/mar-1136-prove-bounded-upgrade-path-on-geohub-and-enrichment-samples.md`

## Correction Set

### 1) Promote Packet Evidence to a Required Operating Primitive
Correction:
- Every stage completion must publish packet evidence at the canonical path convention:
  - `docs/projects/marketgrid/packets/{issue_id}/{batch_id}/{stage}.packet.json`
- Heartbeat progress comments are valid only when they include `stage`, `batch_id`, packet path, and resolved next action.

Reason from evidence:
- Deterministic routing and auditability stabilized only after packet conventions were made explicit in `MAR-1122` and enforced in `MAR-1124`/`MAR-1125`.

### 2) Freeze Outcome-Driven Routing as the Single Execution Gate
Correction:
- Transfer eligibility and next-stage routing must be derived only from canonical validator outcomes.
- Non-canonical outcome labels are treated as execution invalidity, not soft warnings.

Reason from evidence:
- Outcome drift risk was repeatedly identified and then contained by bounded checks in `MAR-1125` and `MAR-1130`.

### 3) Make Backward Transitions First-Class Invariants
Correction:
- Require explicit evidence for:
  - `transition:validate:fail->enrich`
  - `transition:generate:qa_fail->validate`
- Missing backward transition evidence is a hard `NO-GO` for a slice.

Reason from evidence:
- Reverse-lane determinism was ambiguous before explicit transition evidence was added and verified in `MAR-1124`/`MAR-1125`.

### 4) Adopt Version Governance as Runtime Policy, Not Documentation Policy
Correction:
- `contract_version` and `artifact_revision` are required for packet/enrichment payloads.
- `standard_version`, `schema_version`, and related metadata are required in working-document registry entries.
- Validators/pipeline scripts must fail fast when version metadata is missing.

Reason from evidence:
- Version policy became reliably enforceable only after runtime checks were introduced in `MAR-1134` and `MAR-1135`.

### 5) Introduce Explicit Compatibility Window Governance
Correction:
- Define and continuously enforce bounded upgrade windows (`v1.0` and `v1.1` accepted; out-of-window versions rejected unless a planned window update is approved).
- Keep acceptance/rejection behavior executable via one bounded proof script.

Reason from evidence:
- Contract safety around upgrades was only proven once explicit accept/reject fixtures and script checks were added in `MAR-1136`.

### 6) Standardize Input-Normalized Diff Testing for Build Parity Claims
Correction:
- Any build parity claim must include an input-normalized rerun (same base URL and input set) before declaring structural drift.
- Non-normalized diffs are diagnostic only.

Reason from evidence:
- `MAR-1131` showed an apparent difference was configuration-induced (`base_url`) and disappeared under input-normalized rerun.

### 7) Codify Pattern Extraction Over System Import
Correction:
- External systems may contribute patterns, but runtime authority remains repo-local (`docs/system/*`, `docs/pages/*`, `docs/schema/*`, `docs/implementation/*`).
- Adoption work must classify items as `adopt now`, `adopt with constraints`, or `defer/reject` before implementation.

Reason from evidence:
- `MAR-1129` and `MAR-1130` succeeded by constrained pattern extraction and explicit exclusions, avoiding dual-authority drift.

## Operating Rules to Apply Immediately
1. No stage completion without canonical packet evidence and resolver proof.
2. No validator outcome extensions without a contract change issue and bounded verification update in the same slice.
3. No version metadata omissions accepted in packets, enrichment payloads, or working-document registry.
4. No upgrade-window expansion without adding/refreshing acceptance and rejection fixtures and rerunning bounded proof.
5. No build difference conclusions without an input-normalized parity rerun.

## Implementation Impact
- No new systems required.
- Corrections are extensions of already-delivered `MAR-1122` through `MAR-1136` behavior.
- Net effect: stricter execution determinism, lower drift risk, and better cross-issue reproducibility.

## Final Disposition
- `GO`: adopt these corrections as the active operating model for subsequent MarketGrid pipeline slices.
