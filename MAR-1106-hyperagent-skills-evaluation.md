# MAR-1106 HyperAgent Skills Evaluation

Date: 2026-05-24
Scope: Evaluation only (no implementation)
Source reviewed: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/hyperagent/skills/`

## Executive Summary

The HyperAgent export contains high-value operational playbooks for MarketGrid, especially around geohub enrichment routing, packet schema/validation, source hierarchy discipline, and staged pipeline quality control. The most useful assets are process contracts that can be adapted into Paperclip skills and governance docs without inheriting HyperAgent-specific runtime assumptions.

Main caution: several skills encode model-specific orchestration, fixed vertical assumptions, or reconstructed memory fields. Direct adoption would introduce architecture drift and false-confidence risk. The right strategy is selective rewrite into Paperclip-native protocols, preserving existing authority order (`docs/system/*`, `docs/pages/*`, `docs/schema/*`) and avoiding parallel systems.

## Brief Synopsis of Skill Inventory

### A) Core MarketGrid geohub pipeline and routing
- `geohub-enrichment-router`: 5-pass execution orchestrator with sequencing and model-tiering discipline.
- `marketgrid-geohub-base-packet-enrichment-protocol`: PASS-001 execution playbook for packet assembly.
- `marketgrid-rsc-enrichment-protocol`: PASS-002 regional service center evidence method.
- `marketgrid-geohub-event-discovery-protocol`: PASS-003 event discovery sourcing and synthesis protocol.
- `category-overlay-triage-protocol`: PASS-004 category overlay prioritization and exclusion rules.
- `marketgrid-parent-child-geo-linking-protocol`: PASS-005 geographic containment/linking protocol.
- `marketgrid-geohub-system-integration-map`: end-to-end interaction/lifecycle map for geohub skills.

### B) Data contracts and validation
- `marketgrid-geohub-packet-schema`: canonical geohub packet field/section contract.
- `marketgrid-geohub-packet-validator`: 12-check quality gate with multi-outcome verdict.
- `marketgrid-geohub-event-data-model`: event schema, lifecycle, recurrence, freshness discipline.
- `marketgrid-json-ld-structured-data-templates`: page/entity JSON-LD templates and emission rules.
- `marketgrid-universal-mvp-listing-schema`: cross-vertical publication gate and minimal listing contract.

### C) Source hierarchy and evidence governance
- `marketgrid-content-generation-guardrails`: evidence taxonomy, claim states, banned phrases, freshness tiers.
- `marketgrid-geo-source-index-creation-protocol`: first-party geo source index build + health-check pattern.
- `marketgrid-geohub-geographic-source-hierarchy`: authority hierarchy for geographic sources.
- `marketgrid-home-services-source-hierarchy`: home-services source ranking and prohibited sources.
- `marketgrid-medical-source-hierarchy`: medical source ranking and prohibited sources.
- `salisbury-md-wicomico-county-first-party-source-index`: concrete local source inventory example.

### D) Vertical overlays and listing schemas
- `marketgrid-category-overlay-interface`: plug-in style contract for vertical overlays.
- `marketgrid-home-services-category-overlay`: home-services overlay template and checklist.
- `marketgrid-home-services-listing-schemas`: home-services listing/validator suite.
- `marketgrid-medical-listing-schemas`: hospital/practice listing contracts and validators.
- `marketgrid-restaurant-listing-schema`: restaurant schema + forbidden language/QA model.
- `marketgrid-listing-content`: source-backed listing content generation protocol.

### E) Delivery workflow and QA operations
- `marketgrid-incremental-build-pipeline`: 5-stage discover->publish pipeline + status model.
- `marketgrid-geohub-initialization-checklist`: preflight readiness gate.
- `marketgrid-triage-disposition-framework`: codified decision trees for data triage.
- `marketgrid-edge-case-failure-catalog`: failure taxonomy and mitigations from production runs.
- `marketgrid-batch-quality-metrics-template`: standardized batch scorecard.
- `marketgrid-demand-validation-framework`: category/subcategory scoring before build investment.
- `marketgrid-transfer-agent-protocol`: packet-to-surface generation constraints and handoff rules.
- `marketgrid-page-type-architecture`: route/page hierarchy and linking model.
- `marketgrid-content-generation-protocol`: Stage-4 generation procedure with QA/handoff.

### F) General-purpose or non-core to current system
- `hyperframes-cli`, `hyperframes-registry`, `website-to-hyperframes`, `remotion-to-hyperframes`, `video-prompting`, `advanced-image-techniques`, `docx`, `pptx`.
- Synopsis: mostly content/media tooling and conversion workflows, not core MarketGrid authority or runtime architecture.

## Usefulness vs Risk Ranking

Scale:
- Usefulness: `High`, `Medium`, `Low`
- Risk: `Low`, `Medium`, `High`

### Tier 1: High usefulness, low-medium risk (best mining targets)
1. `marketgrid-geohub-packet-validator` — Usefulness: High, Risk: Medium
2. `marketgrid-geohub-packet-schema` — Usefulness: High, Risk: Low
3. `marketgrid-content-generation-guardrails` — Usefulness: High, Risk: Medium
4. `marketgrid-incremental-build-pipeline` — Usefulness: High, Risk: Low
5. `marketgrid-geohub-system-integration-map` — Usefulness: High, Risk: Medium
6. `marketgrid-geo-source-index-creation-protocol` — Usefulness: High, Risk: Medium
7. `marketgrid-category-overlay-interface` — Usefulness: High, Risk: Medium
8. `marketgrid-universal-mvp-listing-schema` — Usefulness: High, Risk: Medium

### Tier 2: High usefulness, medium-high risk (adapt carefully)
9. `geohub-enrichment-router` — Usefulness: High, Risk: High (model/runtime coupling)
10. `marketgrid-transfer-agent-protocol` — Usefulness: High, Risk: High (surface-generation coupling)
11. `marketgrid-content-generation-protocol` — Usefulness: High, Risk: High (voice/runtime coupling)
12. `marketgrid-json-ld-structured-data-templates` — Usefulness: Medium-High, Risk: Medium
13. `marketgrid-geohub-event-discovery-protocol` — Usefulness: Medium-High, Risk: Medium
14. `marketgrid-rsc-enrichment-protocol` — Usefulness: Medium-High, Risk: Medium
15. `marketgrid-demand-validation-framework` — Usefulness: Medium-High, Risk: Medium

### Tier 3: Contextual value, moderate risk
16. `marketgrid-geohub-base-packet-enrichment-protocol`
17. `category-overlay-triage-protocol`
18. `marketgrid-parent-child-geo-linking-protocol`
19. `marketgrid-geohub-event-data-model`
20. `marketgrid-home-services-source-hierarchy`
21. `marketgrid-medical-source-hierarchy`
22. `marketgrid-geohub-initialization-checklist`
23. `marketgrid-triage-disposition-framework`
24. `marketgrid-edge-case-failure-catalog`
25. `marketgrid-batch-quality-metrics-template`
26. `marketgrid-page-type-architecture`
27. `marketgrid-listing-content`
28. `marketgrid-restaurant-listing-schema`
29. `marketgrid-home-services-listing-schemas`
30. `marketgrid-medical-listing-schemas`
31. `marketgrid-home-services-category-overlay`
32. `salisbury-md-wicomico-county-first-party-source-index`

### Tier 4: Low relevance for current Paperclip/MarketGrid core system
33. `hyperframes-cli`
34. `hyperframes-registry`
35. `website-to-hyperframes`
36. `remotion-to-hyperframes`
37. `video-prompting`
38. `advanced-image-techniques`
39. `docx`
40. `pptx`

## Improvement Opportunities for Paperclip

1. Introduce first-class validation protocol templates.
- Opportunity: Convert packet/listing validators into reusable Paperclip check frameworks with explicit fail/warn/pass outcomes.
- Benefit: deterministic quality gates and better cross-agent consistency.

2. Add source-authority governance primitives.
- Opportunity: Lift source hierarchy and evidence taxonomy patterns into central governance docs and reusable skill boilerplates.
- Benefit: tighter factuality controls and reduced claim drift.

3. Add stage-gated pipeline issue patterns.
- Opportunity: Encode discover/enrich/validate/generate/publish stages as task templates with required artifacts and blockers.
- Benefit: predictable throughput, easier triage, better resume semantics.

4. Standardize triage decision trees.
- Opportunity: Convert triage/disposition trees into a shared incident/data-quality runbook format.
- Benefit: faster conflict resolution and less ad hoc judgment variance.

5. Build vertical overlay contract pattern.
- Opportunity: Use category-overlay interface as a pattern for pluggable vertical packs (schema + sources + validators).
- Benefit: scalability to new verticals without redefining core runtime.

## Gaps and Risks if Adopted Poorly

1. Runtime/model lock-in risk.
- Many protocols assume specific model-tier orchestration and tool behavior; direct copy would age quickly.

2. Parallel-governance risk.
- HyperAgent docs can conflict with existing authority docs; importing wholesale would create dual sources of truth.

3. Over-engineering risk.
- Several assets are heavy-weight and could exceed current MVP complexity budget.

4. False certainty risk.
- Some schema docs explicitly include reconstructed fields; these must not be treated as canonical without re-validation.

5. Vertical leakage risk.
- Medical/home-services assumptions may contaminate universal templates if not isolated.

## Recommended Mining Strategy (No Implementation)

1. Mine only transferable patterns, not implementations.
- Keep contracts/patterns; rewrite all runtime specifics.

2. Use authority-first rewrite.
- Every mined concept must be reconciled against existing `docs/system/*`, `docs/pages/*`, and `docs/schema/*` before adoption.

3. Start with three low-risk/high-value extractions.
- Packet validator outcome model.
- Source hierarchy + evidence taxonomy template.
- Stage-gated pipeline checklist model.

4. Require provenance labels in mined docs.
- Mark each imported concept as: accepted, adapted, or rejected with rationale.

## Final Assessment

HyperAgent skill output is a strong process-intelligence artifact set for MarketGrid operations. The best value is in protocol structure, validation rigor, and source-governance discipline. The largest risk is direct portability. Adaptation should be deliberate, authority-constrained, and Paperclip-native.
