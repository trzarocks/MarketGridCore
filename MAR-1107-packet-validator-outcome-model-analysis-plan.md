# MAR-1107 Packet Validator Outcome Model Analysis and Plan

Date: 2026-05-23
Owner: CTO
Scope: Outcome-model analysis and implementation plan (no runtime implementation in this issue)

## Authority Inputs Used

- `docs/agents/cto-start-here.md`
- `hyperagent/skills/marketgrid-geohub-packet-validator/documentation.md`
- `hyperagent/skills/marketgrid-geohub-packet-schema/documentation.md`
- `MAR-1106-hyperagent-skills-evaluation.md` (prior mining outcome)

## Current Outcome Model (As-Is)

The current validator model is a four-state outcome with explicit transfer eligibility:

1. `PASS-generation-ready`
- No `FAIL` checks.
- At least one approved claim.
- Transfer eligible.

2. `PASS-with-waivers-generation-ready`
- No `FAIL` checks.
- At least one approved claim.
- One or more waivered `WARN` checks.
- Transfer eligible.

3. `PASS-research-grade`
- Structurally valid packet.
- Zero approved claims allowed.
- Not transfer eligible.

4. `FAIL`
- Any unresolved `FAIL` check.
- Not transfer eligible.

The model is backed by 12 validator checks (`GP01`..`GP12`) with mixed hard-gate and scoring/warn semantics, plus explicit never-waiverable checks (`GP06`, `GP12`).

## Outcome-Model Strengths

1. Clear separation between structural validity and transfer readiness.
2. Explicit allowance for research-storage state (`PASS-research-grade`) without unsafe transfer.
3. Never-waiverable safety checks guard against high-risk publication drift.
4. Thresholded evidence/citation gates reduce subjective judgment variance.

## Outcome-Model Gaps To Address

1. Outcome naming drift
- `PASS-with-waivers-generation-ready` is semantically consistent but format-inconsistent with `PASS-generation-ready` and `PASS-research-grade`.
- Risk: downstream parsers/filters treating outcomes as free-form labels.

2. Check-to-outcome mapping is implicit in prose
- The exact conversion from per-check states to final outcome is not yet expressed as a deterministic truth table artifact.
- Risk: different agents derive different outcomes on borderline packets.

3. Waiver payload schema is underspecified
- Waiver eligibility exists, but required fields per waiver record are not formalized in a durable schema.
- Risk: untraceable waiver decisions and weak auditability.

4. Transfer eligibility logic is duplicated conceptually
- Outcome labels encode eligibility, and transfer rules also encode eligibility.
- Risk: future divergence between outcome strings and transfer gate behavior.

5. Research-grade boundary is binary-only on approved claims
- Current boundary uses approved-claim count and structural validity, but does not require minimum citation coverage quality narrative for the storage state.
- Risk: low-quality but structurally complete packets accumulating as "research-grade."

## Recommended Target Model (To-Be)

Keep the same four outcomes (no new system), but formalize them as a deterministic outcome contract:

1. Canonical outcome enum (stable string set)
- `pass_generation_ready`
- `pass_with_waivers_generation_ready`
- `pass_research_grade`
- `fail`

2. Machine-readable outcome resolver
- Inputs: per-check result set, approved-claim count, waiver records.
- Output: one outcome enum + transfer eligibility boolean.

3. First-class waiver schema
- Required per waiver: `check_id`, `severity`, `rationale`, `owner`, `created_at`, `expires_at` (optional), `mitigation`.
- Explicit disallow list for never-waiverable checks (`GP06`, `GP12`).

4. Single transfer eligibility source of truth
- Eligibility derived only from resolved outcome enum.
- Avoid duplicate branch logic in transfer paths.

5. Research-grade quality floor (non-transfer)
- Preserve non-transfer status.
- Add minimum quality assertions for storage acceptance (for example: no hard-gate failures, claim inventory consistency intact).

## Deterministic Resolution Order

1. Evaluate hard-gate failures first.
2. Enforce never-waiverable checks.
3. Apply valid waivers to waiver-eligible warnings.
4. Compute approved-claim count.
5. Resolve final outcome via ordered rules:
- If any unresolved hard failure: `fail`.
- Else if approved claims >= 1 and any active waiver: `pass_with_waivers_generation_ready`.
- Else if approved claims >= 1 and no active waiver: `pass_generation_ready`.
- Else: `pass_research_grade`.

## Implementation Plan

### Phase 1: Contract codification

1. Add/extend schema doc section for:
- canonical outcome enum
- waiver record schema
- deterministic resolution order

2. Add validator-spec doc section for:
- check severity map
- waiver eligibility matrix
- outcome truth table examples

Deliverable: docs-only contract update (no runtime behavior change).

### Phase 2: Runtime alignment

1. Normalize runtime outcome strings to canonical enum.
2. Implement centralized resolver function used by validator output and transfer gates.
3. Add explicit transfer-eligibility field derived from resolver output.

Deliverable: runtime emits stable outcome + eligibility with no duplicated gate logic.

### Phase 3: Verification and migration

1. Add fixture packets covering:
- pass generation ready
- pass with waivers
- pass research grade
- fail (never-waiverable + hard failure cases)

2. Add regression checks for:
- waiver rejection on `GP06` and `GP12`
- identical transfer gate decisions before/after normalization for unchanged outcomes

3. Add backward-compat mapping for legacy strings in readers, with deprecation note.

Deliverable: safe migration path without breaking existing consumers.

## Risks and Mitigations

1. Risk: Legacy consumers depend on old outcome strings.
- Mitigation: compatibility mapper + staged deprecation window.

2. Risk: Waiver metadata overhead slows validator operations.
- Mitigation: minimal required waiver fields and default serializer.

3. Risk: Resolver drift across code paths.
- Mitigation: single resolver module with fixture-based contract tests.

## Exit Criteria for MAR-1107

1. Outcome model documented as deterministic contract artifact.
2. Canonical enum and waiver schema defined with non-waiverable constraints.
3. Phased implementation plan captured with verification gates.
4. No new parallel validation system proposed; plan extends current packet validator/schema contracts only.
