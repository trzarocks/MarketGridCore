# MAR-1190 Geohub Intelligence Packet Gate Integration Plan

Date: 2026-05-27
Owner: CTO
Status: Delivered (planning)
Issue: MAR-1190
Parent Authority Packet: MAR-1189 comment `85f01409-3812-441d-a0a1-bb75eb522685`

## Objective
Define the minimal MarketGrid control points to enforce this operational rule without introducing a new system:

`A new geography must not proceed to category-page generation unless an approved Geohub Intelligence Packet exists, or the current task explicitly includes creating that packet.`

## Skill Reference Requirement
Board instruction requires this exact authoritative skill reference:
1. Skill ID: `skills/5185d615-76d8-4951-99a1-a25ca749f89e`
2. Registry name: `Build Geohub Intelligence Packet`
3. Slug: `build-geohub-intelligence-packet`
4. Description: `Use to build the geohub intelligence that becomes the source of truth for marketgrid geohubs`

Findings:
1. This exact skill ID is not present as a local filesystem path in the current checkout.
2. The closest in-repo integration surfaces already in use are HyperAgent reference docs:
- `hyperagent/skills/marketgrid-incremental-build-pipeline/documentation.md`
- `hyperagent/skills/marketgrid-page-type-architecture/documentation.md`
3. For execution, treat the board-provided skill ID as the authoritative external skill reference, and translate enforcement into current repo-local canonical workflow docs/scripts.

## Workflow Entry Placement (Required)
The authoritative skill enters the workflow at the first gate for any new geography:

`New geohub requested -> Run skill build-geohub-intelligence-packet (Build Geohub Intelligence Packet / skills/5185d615-76d8-4951-99a1-a25ca749f89e) -> Review/approve packet -> Category-source packet -> Normalize seed/listing data -> Generate geo/category/listing pages -> Validate content quality`

Operational gate mapping:
1. No batch may take a `validate:*->generate` transition unless prerequisite evidence traces to either:
- an approved output from `Build Geohub Intelligence Packet`, or
- in-task creation output from the same skill.
2. Supporting packet/schema/validator artifacts are secondary translation inputs only and cannot substitute for this named skill as the upstream gate origin.

## Current Workflow Baseline (Control Surfaces)
Primary canonical control point:
1. `docs/implementation/incremental-build-pipeline.md`
- Already defines canonical stage order, canonical outcomes, runtime wiring, and deterministic transition resolver.
- Already states geohub stabilization intent, but does not yet define a machine-checkable prerequisite gate for category-page generation.

Verification control point:
2. `docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`
- Already verifies canonical outcomes, transition mapping, and packet path coherence.
- Does not yet verify that generation-eligible batches carry approved geohub prerequisite evidence.

Reference-only authority inputs (no direct runtime authority):
3. `docs/projects/marketgrid/mar-1129-hyperagent-geohub-adoption-report.md`
4. `hyperagent/skills/marketgrid-incremental-build-pipeline/documentation.md`
5. `hyperagent/skills/marketgrid-page-type-architecture/documentation.md`

## Minimal Integration Path (Single Path)
### Decision
Enforce the geohub packet prerequisite in the canonical workflow contract (`docs/implementation/incremental-build-pipeline.md`), and prove it with one bounded verifier update (`docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`).

### Why this is minimal and canonical
1. Uses existing runtime contract and existing verifier wrapper.
2. Avoids new orchestrators, runtimes, or schemas.
3. Preserves canonical validator outcomes and packet envelope behavior.
4. Keeps enforcement auditable via repo-local packet evidence.

## Concrete Change List for MAR-1191 (Execution)
1. Update `docs/implementation/incremental-build-pipeline.md`:
- Add a new subsection: `Geohub Intelligence Packet Prerequisite Gate` under `Runtime Wiring Contract`.
- Define gate enforcement at the transition boundary before any category/listing generation path.
- Require stage packets that can lead to `generate` to include explicit geohub prerequisite evidence in `input_refs` pointing to one of:
  - approved geohub packet artifact, or
  - current-task geohub packet creation artifact.
- Define accepted approval floor as `pass_research_grade` or stronger (`pass_with_waivers_generation_ready`, `pass_generation_ready`) per parent authority packet.
- Define deterministic failure action when evidence is missing: block `validate -> generate` transition and route back as non-transfer-eligible (no custom outcome labels).

2. Update `docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`:
- Add `CHECK4` to assert geohub prerequisite evidence exists for every batch that has `transition:validate:*->generate`.
- `CHECK4` should be bounded and path-based, using existing packet JSON fields and refs; do not introduce new packet schema.
- `CHECK4` should fail when a generation-eligible transition exists without prerequisite reference evidence.

3. Optional (only if needed for clarity, not new authority):
- Add one execution note under `docs/projects/marketgrid/` documenting expected evidence-ref pattern for geohub prerequisite traceability.

## Enforcement Placement Recommendation
Recommendation: enforce directly in `docs/implementation/incremental-build-pipeline.md` plus bounded proof in `verify-geohub-adoption.sh`.

Not recommended: implementing this gate only inside ad-hoc run instructions or issue comments, because that is not canonical and is harder to audit.

## External HyperAgent Artifact Policy
Explicit disposition:
1. `skills/5185d615-76d8-4951-99a1-a25ca749f89e` (`Build Geohub Intelligence Packet`, slug `build-geohub-intelligence-packet`) is the authoritative upstream skill identity from board instruction.
2. External/HyperAgent assets are reference input only.
3. Runtime enforcement must be translated into MarketGrid repo-local canonical docs/scripts above.
4. No verbatim import of external orchestration behavior.

## Bounded Verification Method for MAR-1191
Run only bounded checks:
1. `bash docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`
2. Confirm new `CHECK4` output passes on sample packet sets and verifies geohub prerequisite evidence is traced to `build-geohub-intelligence-packet` (`skills/5185d615-76d8-4951-99a1-a25ca749f89e`) for generation-eligible transitions.
3. Spot-check updated canonical section exists:
- `rg -n "Geohub Intelligence Packet Prerequisite Gate|CHECK4|transition:validate:" -S docs/implementation/incremental-build-pipeline.md docs/projects/marketgrid/scripts/verify-geohub-adoption.sh`

## Ready-for-Execution Handoff
MAR-1191 can implement without inferred intent:
1. Canonical enforcement location is fixed.
2. Verifier extension scope is fixed.
3. Outcome model/pipeline envelope constraints are preserved.
4. External skill reference policy is explicit.
