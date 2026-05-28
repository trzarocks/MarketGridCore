# Incremental Build Pipeline

Date: 2026-05-23
Owner: CTO
Status: Delivered

## Purpose
Canonical Paperclip-native implementation artifact for the MarketGrid incremental-build pipeline. This file is the repo-local deliverable and the source for issue/heartbeat execution handoffs.

## Source Contract
Adapted from the repo-local incremental-build source documentation:
- `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`

Preserved pipeline contract:
1. Five stages: `discover -> enrich -> validate -> generate -> publish`
2. Canonical validator outcomes:
- `pass_generation_ready`
- `pass_with_waivers_generation_ready`
- `pass_research_grade`
- `fail`
3. Record lifecycle:
- `discovered -> enriched -> validated -> generated -> published -> stale -> retired`
4. Backward transitions:
- validation failure returns to `enriched`
- post-generation QA failure returns to `validated`

## GeoHub Adoption Baseline
This baseline locks the approved subset from HyperAgent GeoHub analysis into Paperclip-native implementation constraints.

Adopted and required:
1. Canonical packet envelope with deterministic stage artifacts.
2. Canonical validate outcomes only:
   - `pass_generation_ready`
   - `pass_with_waivers_generation_ready`
   - `pass_research_grade`
   - `fail`
3. Outcome-driven transfer eligibility with explicit transition evidence.
4. Staged execution sequence only: `discover -> enrich -> validate -> generate -> publish`.
5. Explicit backward-transition evidence:
   - `transition:validate:fail->enrich`
   - `transition:generate:qa_fail->validate`

Not adopted in this baseline:
1. Model-tier orchestration routers.
2. Event discovery/data-model integration beyond current packet contract.
3. Any second authority source that competes with `docs/system/*`, `docs/pages/*`, or `docs/schema/*`.

## Stage Packet Shape
Each stage emits a deterministic packet with the same envelope:

```json
{
  "contract_version": "v1.1",
  "artifact_revision": 1,
  "issue": "MAR-1116",
  "pipeline": "marketgrid_incremental_build",
  "stage": "discover|enrich|validate|generate|publish",
  "batch_id": "string",
  "input_refs": ["path-or-issue-link"],
  "output_refs": ["path-or-issue-link"],
  "quality_gate": {
    "status": "pass|fail",
    "reason_codes": ["string"]
  },
  "metrics": {
    "records_in": 0,
    "records_out": 0,
    "duration_seconds": 0
  }
}
```

Required envelope fields:
1. `contract_version`
2. `artifact_revision`
3. `issue`
4. `pipeline`
5. `stage`
6. `batch_id`
7. `input_refs`
8. `output_refs`
9. `quality_gate.status`
10. `metrics.records_in`
11. `metrics.records_out`
12. `metrics.duration_seconds`

Absent metadata rule:
1. If `contract_version` or `artifact_revision` is missing, the packet is invalid for storage and downstream consumption.
2. Consumers must not infer missing values from file path, issue id, or previous packets.

## Runtime Wiring Contract
This section defines deterministic heartbeat behavior for each stage and outcome. It is the canonical execution mapping for Paperclip issue runs.

### Packet Persistence Convention
Persist all stage packets under one repo-local path:
- `docs/projects/marketgrid/packets/{issue_id}/{batch_id}/{stage}.packet.json`

Conventions:
1. `issue_id` matches the executing issue key (example: `MAR-1122`).
2. `batch_id` is stable for the batch across all five stages.
3. `stage` must be one of `discover|enrich|validate|generate|publish`.
4. One packet file per stage per batch; stage retries overwrite the same path and increment `artifact_revision` in-file when needed.
5. `contract_version` declares the packet-envelope contract consumed by storage and downstream validators.
6. Packet core fields must cohere with path segments:
   - packet `.issue` equals `{issue_id}` directory
   - packet `.batch_id` equals `{batch_id}` directory
   - packet `.stage` aligns with the stage filename prefix (`{stage}.packet.json` or `{stage}-*.packet.json`)

### Heartbeat Action Mapping
Each stage completion heartbeat must do all of the following:
1. write/update the stage packet file using the required envelope
2. include packet path in `output_refs`
3. post structured progress evidence that names `stage`, `batch_id`, and resolved next action

### Stage-to-Action Resolver
Deterministic next action by stage result:
1. `discover` complete -> continue same batch to `enrich`
2. `enrich` gate pass -> continue same batch to `validate`
3. `validate` outcome `pass_generation_ready` -> continue same batch to `generate`
4. `validate` outcome `pass_with_waivers_generation_ready` -> continue same batch to `generate`
5. `validate` outcome `pass_research_grade` -> mark records store-only, do not schedule `generate`
6. `validate` outcome `fail` -> return same records to `enrich`
7. `generate` QA pass -> continue same batch to `publish`
8. `generate` QA fail -> return same records to `validate`
9. `publish` gate pass -> mark batch complete

Resolver rules:
1. `validate` transfer eligibility is derived from canonical outcome only.
2. No custom outcome labels are allowed in packet routing logic.
3. Backward transitions must appear explicitly in packet trail (`validate:fail -> enrich`, `generate:qa_fail -> validate`).

### Geohub Intelligence Packet Prerequisite Gate
This gate applies before any category/listing generation path is allowed to run.

Required upstream skill identity:
1. `skills/5185d615-76d8-4951-99a1-a25ca749f89e`
2. Registry name: `Build Geohub Intelligence Packet`
3. Slug: `build-geohub-intelligence-packet`

Gate enforcement rules:
1. Any `validate` packet that routes to `generate` via
   - `transition:validate:pass_generation_ready->generate`, or
   - `transition:validate:pass_with_waivers_generation_ready->generate`
   must include explicit geohub prerequisite evidence in `input_refs`.
2. The prerequisite evidence must trace to one of:
   - an approved geohub packet artifact, or
   - a current-task geohub packet creation artifact.
3. Approval floor for accepted geohub packet evidence is `pass_research_grade` or stronger:
   - `pass_research_grade`
   - `pass_with_waivers_generation_ready`
   - `pass_generation_ready`
4. If geohub prerequisite evidence is missing, routing to `generate` is invalid and the batch remains non-transfer-eligible for generation.

Evidence traceability requirement:
1. Repo-local workflow notes, proof artifacts, and verifier outputs for this gate must name the upstream skill identity above so integration cannot drift to a different geohub packet source.

## Stage Definitions

### `discover`
- Inputs: geohub boundary plus Tier-1 source definitions.
- Work: candidate crawl, dedupe, normalization.
- Output gate: none; all candidates continue.
- Batch guidance: `10-25` entities.

### `enrich`
- Inputs: discovered entities.
- Work: ordered fill `T1 -> T2 -> T3` with field-level evidence rows and crawl outcomes.
- Crawl outcomes: `found`, `no_findings`, `inaccessible`.
- Output gate: all required T1 fields populated.
- Batch guidance: `5-10` entities.

### `validate`
- Inputs: enriched entities.
- Work: run overlay validators and resolve one canonical outcome.
- Canonical outcomes only:
  - `pass_generation_ready`
  - `pass_with_waivers_generation_ready`
  - `pass_research_grade`
  - `fail`
- Transfer eligibility derives only from the resolved canonical outcome.
- Output gate:
  - advance to `generate` on `pass_generation_ready` or `pass_with_waivers_generation_ready`
  - store-only on `pass_research_grade`
  - return to `enrich` on `fail`

### `generate`
- Inputs: generation-ready entities.
- Work: listing content, JSON-LD, category cards.
- QA checks:
  - banned-phrase scan
  - citation presence check
  - claim-state audit
- Failure path: return to `validated`.
- Batch guidance: `5-10` pages.

### `publish`
- Inputs: QA-passed generated pages.
- Work: canonical URL update, category update, sitemap update, freshness monitor registration.
- Output gate: publish packet present with route and timestamp evidence.

## Record Lifecycle
`discovered -> enriched -> validated -> generated -> published -> stale -> retired`

Backward transitions:
- validation failure returns to `enrich`  
- post-generation QA failure returns to `validated`
- freshness expiry moves to `stale`

## Incremental Execution Principles
1. Keep batches small (`5-25`).
2. Execute a vertical slice first (`3-5` listings end-to-end) before scaling.
3. Preserve stage independence and explicit handoffs.
4. Keep feedback loops short; regress the stage on gate failure.
5. Stabilize geohub packet quality before category expansion.

## Monitoring Metrics
Track per-stage packet metrics:
- `records_in`
- `records_out`
- `duration_seconds`
- gate pass/fail counts by canonical outcome

## Paperclip Wiring
Repo-local wiring and discoverability evidence:
- This file is the canonical implementation artifact under `docs/implementation/`.
- The upstream contract capture is maintained in `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`.
- Placement and wiring evidence is maintained in `docs/projects/marketgrid/mar-1116-incremental-build-artifact-placement-and-wiring-evidence.md`.
- Shared-path delivery evidence is maintained in `docs/projects/marketgrid/mar-1118-deliver-incremental-build-artifact-into-shared-marketgrid-repo-paths.md`.
- Step-1 runtime wiring contract evidence is maintained in `docs/projects/marketgrid/mar-1122-step-1-runtime-wiring-contract.md`.

## Verification Commands
```bash
find docs/implementation -maxdepth 1 -type f | sort
sed -n '1,220p' docs/implementation/incremental-build-pipeline.md
rg -n "Source Contract|Paperclip Wiring|Verification Commands" -S docs/implementation/incremental-build-pipeline.md
rg -n "Runtime Wiring Contract|Packet Persistence Convention|Stage-to-Action Resolver" -S docs/implementation/incremental-build-pipeline.md
rg -n "/var/home|/home/trza" -S docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md docs/projects/marketgrid/mar-1116-incremental-build-artifact-placement-and-wiring-evidence.md docs/projects/marketgrid/mar-1117-move-incremental-build-delivery-into-shared-repo-local-paths.md

# Step 4 minimal verification wiring (sample packet set)
# 1) only canonical validate outcomes are used
if rg -n "outcome:" -S docs/projects/marketgrid/packets/MAR-1124 \
  | rg -v "outcome:(pass_generation_ready|pass_with_waivers_generation_ready|pass_research_grade|fail)"; then
  echo "NON_CANONICAL_OUTCOME_FOUND"
  exit 1
else
  echo "CHECK1_OK: canonical outcomes only"
fi

# 2) transfer eligibility is derived from validate outcome only
jq -r '
  select(.stage == "validate")
  | [.batch_id, (.quality_gate.reason_codes[]? | select(startswith("outcome:"))), (.quality_gate.reason_codes[]? | select(startswith("transition:validate:")))] | @tsv
' docs/projects/marketgrid/packets/MAR-1124/*/*.json

# 3) backward transitions are explicitly present where required
rg -n "transition:validate:fail->enrich|transition:generate:qa_fail->validate" -S \
  docs/projects/marketgrid/packets/MAR-1124

# Wrapper: bounded GeoHub adoption verification
bash docs/projects/marketgrid/scripts/verify-geohub-adoption.sh

# Working-document registry version fields are required
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
