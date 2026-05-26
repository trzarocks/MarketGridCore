# MAR-1122 Step 1 Runtime Wiring Contract

Date: 2026-05-24
Owner: CTO
Status: Delivered

## Objective
Implement Step 1 contract hardening for the incremental-build skill integration by locking deterministic runtime wiring and packet persistence under repo-local paths.

## Contract Applied
Canonical implementation contract updated in:
- `docs/implementation/incremental-build-pipeline.md`

Step 1 wiring decisions:
1. Packet persistence path convention:
- `docs/projects/marketgrid/packets/{issue_id}/{batch_id}/{stage}.packet.json`
2. Required stage packet envelope fields are explicit and mandatory.
3. Stage-to-action resolver is explicit for all canonical validate outcomes and generate QA outcomes.
4. Backward transitions are mandatory packet-trail evidence:
- `validate:fail -> enrich`
- `generate:qa_fail -> validate`

## Why This Is Sufficient For Step 1
1. Resolves the open path-convention unknown with one deterministic repo-local convention.
2. Encodes transfer eligibility and routing into canonical outcome rules only.
3. Aligns issue heartbeat behavior with the existing system execution contract without introducing new systems.

## Conflict Check
Reviewed against `docs/system/agent-execution-contract.md` and the approved integration plan path in `docs/projects/marketgrid/mar-1121-incremental-build-pipeline-skill-integration-plan.md`.

Stop/Go result:
- `GO` for Step 1 completion
- `NO-GO` for Step 2 implementation in this issue until a separate Step 2 execution pass is opened

Reason:
1. Step 1 scope is complete and does not conflict with the execution-contract gate requirements.
2. Step 2 skill-doc adaptation is explicitly out of scope for this issue and should proceed in its own lane.

## Bounded Verification
```bash
rg -n "Runtime Wiring Contract|Packet Persistence Convention|Stage-to-Action Resolver" -S \
  docs/implementation/incremental-build-pipeline.md

rg -n "docs/projects/marketgrid/packets/\\{issue_id\\}/\\{batch_id\\}/\\{stage\\}\\.packet\\.json" -S \
  docs/implementation/incremental-build-pipeline.md \
  docs/projects/marketgrid/mar-1122-step-1-runtime-wiring-contract.md
```

## Result
Step 1 runtime wiring contract is now explicit, deterministic, and repo-local. This unblocks Step 2 skill-doc adaptation under the same packet and resolver contract.
