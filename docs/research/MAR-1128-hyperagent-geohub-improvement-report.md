# MAR-1128 Hyperagent GeoHub Improvement Report

Date: 2026-05-24
Owner: CTO
Status: Delivered

## Executive Summary

The Hyperagent GeoHub materials contain several transferable patterns, but only a narrow subset should be adopted directly. The highest-value candidates are the packet schema, packet validator outcome model, staged incremental build pipeline, and vertical overlay boundary. These are already close to Paperclip-native execution patterns and can be adopted with low architecture risk.

The main constraint is authority control. Hyperagent documents are useful as process intelligence, but they cannot become a second source of truth alongside MarketGrid system/page/schema docs. The correct path is selective extraction: preserve the reusable contracts, normalize them into existing Paperclip execution patterns, and defer any model-tier orchestration or runtime-specific logic.

## Ranked Candidates

### 1. Geohub packet schema
- What it is: A canonical packet envelope for stage outputs and evidence trails.
- Why it is useful: It creates deterministic, machine-checkable stage artifacts.
- Expected benefit: Less ambiguity in issue heartbeats, easier auditability, and cleaner handoff between stages.
- Implementation prerequisites: A single canonical packet envelope in repo-local docs and a shared location for packet artifacts.
- Adoption risk: Low, because it is structural and already compatible with existing packet-based execution.
- Recommended timing: First phase.

### 2. Geohub packet validator outcome model
- What it is: A fixed set of canonical validate outcomes with explicit routing semantics.
- Why it is useful: It prevents outcome drift and keeps transfer eligibility deterministic.
- Expected benefit: Fewer ambiguous validate states and fewer manual interpretation failures in downstream stages.
- Implementation prerequisites: Canonical outcome labels, explicit transition mapping, and bounded verification checks.
- Adoption risk: Low to medium, because future edits could reintroduce non-canonical outcome labels if the contract is not enforced.
- Recommended timing: First phase.

### 3. Incremental build pipeline
- What it is: A staged discover -> enrich -> validate -> generate -> publish execution model.
- Why it is useful: It gives the team a repeatable operating sequence instead of ad hoc handoffs.
- Expected benefit: Better execution predictability, simpler recovery from failure states, and clearer issue ownership.
- Implementation prerequisites: Stage-specific packet evidence, issue/heartbeat mapping, and a minimal verification gate.
- Adoption risk: Low, because the current repository already has Paperclip-native artifacts representing this flow.
- Recommended timing: First phase.

### 4. Category overlay interface
- What it is: A pluggable boundary for vertical-specific behavior without rewriting the core system.
- Why it is useful: It isolates vertical complexity and reduces contamination of universal contracts.
- Expected benefit: Safer extension path for new verticals and less schema sprawl.
- Implementation prerequisites: Clear core-vs-overlay boundary and explicit scope rules for vertical-specific fields.
- Adoption risk: Medium, because overlays can become a backdoor for hidden runtime assumptions if not constrained.
- Recommended timing: Second phase, after packet/validator adoption is stable.

### 5. Geohub system integration map
- What it is: An end-to-end process map for how geohub-related skills and workflows interact.
- Why it is useful: It helps operators understand the lifecycle and prevents orphaned steps.
- Expected benefit: Better operational clarity and easier onboarding of future implementers.
- Implementation prerequisites: Stable stage contracts and a canonical repository of execution artifacts.
- Adoption risk: Medium, because it should remain subordinate to MarketGrid authority docs.
- Recommended timing: Second phase.

### 6. Geo source hierarchy and source index patterns
- What it is: Source-governance discipline for geospatial and local evidence gathering.
- Why it is useful: It improves trustworthiness of inputs and reduces unsupported claims.
- Expected benefit: Better evidence quality and clearer provenance for localized research.
- Implementation prerequisites: A clear authoritative source hierarchy and explicit evidence labeling.
- Adoption risk: Medium, because source hierarchies are easy to overfit to a specific vertical.
- Recommended timing: Second phase or later.

### 7. Event discovery protocol and event data model
- What it is: A workflow and schema for detecting and normalizing events.
- Why it is useful: It can add richer local relevance and freshness to GeoHub outputs.
- Expected benefit: More timely and more locally useful discovery surfaces.
- Implementation prerequisites: Stable packet/validator core plus freshness and recurrence rules.
- Adoption risk: Medium to high, because event logic tends to pull in broader source and freshness complexity.
- Recommended timing: Third phase.

### 8. Model-tier enrichment router
- What it is: A multi-pass orchestration layer with model-tier sequencing.
- Why it is useful: It can coordinate complex enrichment work.
- Expected benefit: Higher throughput on difficult cases when the rest of the pipeline is already stable.
- Implementation prerequisites: Strong governance over orchestration state and runtime dependencies.
- Adoption risk: High, because it introduces model/runtime coupling and increases architecture drift risk.
- Recommended timing: Defer.

## First-Phase Adoption Plan

1. Normalize the packet schema as the canonical evidence envelope.
2. Enforce the validator outcome model with explicit transfer routing.
3. Keep the incremental build pipeline as the only execution sequence for stage work.
4. Add bounded verification checks so non-canonical outcomes cannot reappear silently.
5. Preserve the category overlay boundary as a documented extension point, but do not expand it until the core pipeline is stable.

## Comparison to Current MarketGrid/Paperclip State

The current repository already contains Paperclip-native artifacts for the incremental build pipeline, including stage packets, backward transitions, and bounded verification checks. That means the main adoption work is not invention but normalization: keep the packet and validator patterns, preserve the execution sequence, and reject any Hyperagent-specific orchestration that would create a second runtime authority.

## Hyperagent Files and Folders Examined

- `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/hyperagent/skills/`
- `MAR-1106-hyperagent-skills-evaluation.md`
- `MAR-1111-reconciliation-note.md`
- `docs/projects/marketgrid/mar-1121-incremental-build-pipeline-skill-integration-plan.md`
- `docs/projects/marketgrid/mar-1122-step-1-runtime-wiring-contract.md`
- `docs/projects/marketgrid/mar-1123-step-2-skill-doc-adaptation.md`
- `docs/projects/marketgrid/mar-1124-step-3-execution-evidence-template.md`
- `docs/projects/marketgrid/mar-1125-step-4-minimal-verification-wiring.md`

## Recommendation

Adopt the packet schema, validator outcomes, and staged build pipeline first. Defer orchestration-heavy and event-heavy Hyperagent assets until the low-risk contracts are fully stabilized inside Paperclip-native execution.
