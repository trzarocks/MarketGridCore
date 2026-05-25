# MAR-1121 Integration Plan - Incremental Build Pipeline Skill

Date: 2026-05-24
Owner: CTO
Status: Draft for CEO review

## Objective
Define a single implementation path to integrate the incremental build pipeline skill into current Paperclip execution without introducing a new system and without porting Hyperagent assets verbatim.

## Authority and Inputs Consumed
- `docs/system/guardrails.md`
- `docs/system/role-based-ingestion-map.md`
- `docs/system/agent-execution-contract.md`
- `docs/implementation/page-generation-pipeline.md`
- `docs/implementation/incremental-build-pipeline.md`
- `docs/projects/marketgrid/mar-1115-paperclip-native-incremental-build-artifact.md`
- `hyperagent/skills/marketgrid-incremental-build-pipeline/{metadata.md,documentation.md,scripts/incremental-build-pipeline.md}`

## Current-State Baseline
1. A Paperclip-native incremental pipeline spec already exists at `docs/implementation/incremental-build-pipeline.md`.
2. The canonical five stages, four validator outcomes, lifecycle states, and backward transitions are already normalized into repo-local docs.
3. The remaining integration gap is operational wiring: turning the spec into deterministic skill-run and heartbeat artifacts that can be executed and audited consistently.

## Integration Scope
In scope:
1. Skill-level execution contract and packet templates for stage outputs.
2. Deterministic mapping from stage outcomes to issue/heartbeat actions.
3. Minimal verification hooks for packet schema validity and outcome eligibility enforcement.

Out of scope:
1. New page/content UX behavior.
2. New validator system design.
3. Broad refactor of existing pipeline docs unrelated to execution wiring.

## Architecture Touchpoints (Likely Files/Systems)
1. `docs/implementation/incremental-build-pipeline.md`
- Add explicit "runtime wiring" section with stage-to-heartbeat action mapping and packet storage convention.

2. `docs/projects/marketgrid/` (new execution note for implementation)
- Add an implementation note that defines where packet artifacts live per run/batch and how parent/child issues reference them.

3. `hyperagent/skills/marketgrid-incremental-build-pipeline/documentation.md`
- Adapt usage guidance to point at Paperclip-native packet evidence and canonical outcome resolver behavior.

4. `hyperagent/skills/marketgrid-incremental-build-pipeline/scripts/incremental-build-pipeline.md`
- Keep concept structure, but replace any non-Paperclip assumptions with deterministic execution steps that emit packet evidence in the agreed envelope.

5. Issue workflow contract (Paperclip issue API usage)
- Enforce stage completion updates as structured progress comments with packet refs.
- Enforce transition behavior (`fail -> enrich`, QA fail -> `validated`) as explicit issue-state actions, not implicit narrative notes.

## Script Adaptation Approach (No Verbatim Port)
1. Preserve invariant concepts only:
- stage order
- canonical outcomes
- lifecycle/backward transitions
- batch sizing/vertical-slice constraints

2. Replace Hyperagent-specific wording with Paperclip-native execution primitives:
- issue parent/child ownership for batch lanes
- heartbeat packet evidence updates
- deterministic gate outcomes tied to canonical enums

3. Convert free-form checklists into machine-checkable artifacts:
- required packet fields
- required outcome enum set
- explicit transition target per failure mode

## Ordered Implementation Sequence With Stop/Go Checkpoints
1. Step 1: Contract hardening
- Update `docs/implementation/incremental-build-pipeline.md` with runtime wiring and packet persistence rules.
- Stop/Go: proceed only if no conflict with `docs/system/agent-execution-contract.md` gate requirements.

2. Step 2: Skill doc adaptation
- Update skill `documentation.md` and `scripts/incremental-build-pipeline.md` to reference Paperclip packet outputs and canonical transitions.
- Stop/Go: proceed only if all stage outputs are representable in existing packet envelope (no new schema).

3. Step 3: Execution evidence template
- Add a repo-local template/example packet set for one vertical slice (discover->publish) using canonical outcomes.
- Stop/Go: proceed only if each stage packet validates against envelope and transition trail is unambiguous.

4. Step 4: Minimal verification wiring
- Add bounded verification commands that assert:
  - only canonical validate outcomes are used
  - transfer eligibility is derived from outcome only
  - backward transitions are present where expected
- Stop/Go: proceed only if checks pass on sample artifacts.

5. Step 5: Implementation readiness handoff
- Publish delivery note with touched files, command evidence, and explicit "next implementation issue" scope.
- Stop/Go: handoff only if no unresolved authority conflicts remain.

## Risks, Unknowns, and Blocker Conditions
1. Risk: schema drift between docs and emitted packet artifacts.
- Mitigation: lock packet envelope in one canonical path and validate every example packet against it.

2. Risk: duplicated gate logic reintroduced outside canonical validate outcomes.
- Mitigation: require transfer eligibility checks to read resolved outcome only.

3. Unknown: where packet artifacts should be persisted by default for multi-batch runs.
- Resolution path: decide one repo-local path convention in Step 1 and use it consistently.

4. Blocker condition: authority conflict between system-level execution contract and skill script behavior.
- Unblock owner: CTO.
- Unblock action: update skill script behavior to match system contract; do not alter system contract in implementation lane.

## Minimal Enrichment Test Proposal (for later board review)
Test objective:
- Prove that enrichment quality and transition determinism improve without broad implementation.

Test design (single vertical slice):
1. Select one geohub/category sample with `3-5` candidate entities.
2. Run staged artifacts for `discover -> enrich -> validate` only.
3. Assert enrich output includes explicit crawl outcome per required field (`found|no_findings|inaccessible`).
4. Assert validate emits canonical outcomes only and correct transition decision per record.

Success signal for board:
1. Before/after diff showing reduced ambiguous records at validate stage.
2. Packet evidence showing deterministic next-stage routing per record.
3. Zero non-canonical outcome labels in sample artifacts.

## Definition of Ready for Implementation
Implementation can start when:
1. CEO approves this plan path.
2. Step 1 packet persistence convention is accepted.
3. No unresolved authority conflict remains.
