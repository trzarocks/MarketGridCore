# MAR-1115 Paperclip-Native Artifact - Incremental Build Pipeline

Date: 2026-05-23
Owner: CTO
Status: Delivered

## Objective
Rewrite the incremental-build pipeline specification into a Paperclip-native artifact format that is directly executable in issue/heartbeat workflows without introducing new systems.

## Source Contract Preserved
Canonical source contract is preserved in-repo for shared execution at:
- `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`

Contract elements preserved exactly:
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

## Paperclip-Native Rewrite

### 1) Stage Packet Shape (artifact-level schema)
Each stage emits a deterministic packet with the same envelope:

```json
{
  "issue": "MAR-1115",
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

### 2) Stage Definitions (Paperclip execution mapping)

#### Stage `discover`
- Inputs: geohub boundary + Tier-1 source definitions.
- Work: candidate crawl, dedupe, normalization.
- Output gate: none (all candidates continue).
- Batch guidance: `10-25` entities.

#### Stage `enrich`
- Inputs: discovered entities.
- Work: ordered fill T1 -> T2 -> T3 with field-level evidence rows and crawl outcome state (`found`, `no_findings`, `inaccessible`).
- Output gate: all required T1 fields populated.
- Batch guidance: `5-10` entities.

#### Stage `validate`
- Inputs: enriched entities.
- Work: run overlay validators and resolve one canonical outcome.
- Output gate:
- advance to generate only on `pass_generation_ready` or `pass_with_waivers_generation_ready`
- store-only on `pass_research_grade`
- return-to-enrich on `fail`
- Rule: transfer eligibility derives only from resolved canonical outcome.

#### Stage `generate`
- Inputs: generation-ready entities.
- Work: listing content + JSON-LD + category cards.
- QA gate (all required): banned-phrase scan, citation presence, claim-state audit.
- Failure path: return to `validated`.
- Batch guidance: `5-10` pages.

#### Stage `publish`
- Inputs: QA-passed generated pages.
- Work: canonical URL update, category update, sitemap update, freshness monitor registration.
- Output gate: publish packet present with route and timestamp evidence.

### 3) Paperclip Lifecycle Mapping
The pipeline is represented as a sequence of issue-level artifacts rather than external free-form docs:

1. Parent implementation issue owns full pipeline run state.
2. Child issues may represent stage execution by batch.
3. Every completion heartbeat must attach/update the stage packet artifact.
4. Parent closes only when publish packet(s) are complete and no unresolved blockers remain.

### 4) Minimum Verification Contract
A run is acceptable only when all checks pass:

1. Every generated stage packet validates against the stage packet shape.
2. Validate-stage packets use canonical outcomes only.
3. No packet asserts generation eligibility from any non-canonical label.
4. Backward transitions (`fail -> enrich`, `qa_fail -> validated`) are visible in packet trail.

## Delivery Artifacts
1. This rewrite artifact:
- `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`

## Notes
- This rewrite intentionally extends existing stage-gate patterns; no new execution system was introduced.
- Scope is technical schema/workflow expression only; content and UX instructions remain untouched.
