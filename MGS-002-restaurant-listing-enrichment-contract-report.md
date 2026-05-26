# MGS-002 Restaurant Listing Enrichment Contract Report

## Scope

Create the system-level restaurant listing enrichment contract that explains how raw restaurant listing facts become user-facing, decision-useful runtime copy within the approved listing template.

## Output Paths

- `docs/enrichment/restaurant-listing-enrichment-contract.md`
- `MGS-002-restaurant-listing-enrichment-contract-report.md`

## Sources Reviewed

- `docs/system/site-architecture.md`
- `docs/pages/listing-page-system.md`
- `docs/system/category-governance-system.md`
- `docs/system/common-searches-system.md`
- `docs/system/research-core.md`
- `docs/system/research-enrichment.md`
- `docs/runtime/fallback-behavior.md`
- `docs/runtime/human-place-writing.md`
- `docs/templates/business-listing-template.md`
- `docs/runtime/rendering/listing-renderer-governance.md`
- `docs/design-system/DESIGN.md`
- `salisbury-restaurant-slice/MAR-994-salisbury-restaurant-evidence-pack.md`
- `salisbury-restaurant-slice/MAR-1040-salisbury-runtime-copy-sample-latest-pif-handoff.md`
- `salisbury-restaurant-slice/MAR-1052-salisbury-11-listing-support-copy-handoff.md`
- `payload-test/codex-home/data-pipeline/output/mar997_salisbury_restaurants_runtime/runtime-pages/listing-pages/*.json`
- `marketgrid-core-systems/MAR-1094-towson-chamber-listing-prototype.json`
- `marketgrid-core-systems/MAR-1095-towson-chamber-listing.html`
- `towson-restaurant-slice/MAR-972-banditos-validation.md`
- `towson-restaurant-slice/MAR-972-three-listing-page-copy-handoff.md`
- `docs/validators/demand-validation.md`

## Demand Validation Summary

### PASS

- `Restaurants` remains the canonical category.
- Restaurant-specific enrichment between raw facts and runtime copy is required by direct evidence.
- Minimum fields for meal role, daypart, dining mode, occasion fit, locality basis, confidence, evidence notes, rendering risk, and fallback guidance are supportable.

### FAIL

- New taxonomy branches, new page types, and new geo layers.
- Required enrichment fields for unsupported claims such as popularity, price, parking, or atmosphere.

## Field Contract Summary

Minimum MVP enrichment payload:

- `meal_role`
- `daypart`
- `dining_mode`
- `occasion_fit`
- `locality_basis`
- `use_case_frame`
- `source_confidence`
- `evidence_notes`
- `rendering_risk`
- `fallback_copy_basis`

Reason for this size:

- enough to drive `hero.description`, `Good For`, `When This Fits`, and `Local Context`
- small enough to avoid ontology sprawl or renderer/schema overreach

## Template Mapping Summary

- `hero.description` must come from meal role, dining mode, use-case frame, and bounded locality.
- `what_they_do.summary` is conditional and should suppress when it merely repeats the hero.
- `services_capabilities.items` remains the `Good For` surface.
- `when_to_use.items` is the main enrichment payoff: three decision-useful scenario lines.
- `context_local_fit.items` carries supported locality plus restraint boundaries.
- hero chips remain location/locality cues, not `Good For` tags.

## Fallback Summary

- When confidence drops, copy becomes broader before it becomes speculative.
- Fallback must stay useful to a human.
- Fallback may use citywide or neutral context.
- Fallback must not invent cuisine, district identity, proximity, popularity, price, parking, or atmosphere.

## Prohibited Language Summary

Do not render user-facing wording such as:

- `direct fit confirmation`
- `matches their listed scope`
- `project matches`
- `listing profile`
- `source dataset`
- `runtime payload`
- `category contract`

## Example Coverage Used

Successful evidence cases:

- `Brew River Restaurant & Bar`: downtown, drinks-forward sit-down
- `Cactus Taverna Restaurant`: citywide flexible group dinner
- `Bagel Bakery Cafe`: breakfast with bounded moving-day context
- `Fuji Ramen House`: casual corridor/campus-day meal
- `East Moon Steak House`: fuller corridor sit-down/group dinner

Failure evidence case:

- `Banditos Bar & Kitchen`: raw-fact rendering without restaurant enrichment produced internal, non-human copy

## Checklist Summary

The contract includes a validation checklist covering:

- meal role presence
- daypart clarity
- dining-mode realism
- bounded locality
- hero-chip versus `Good For` separation
- `What They Do` suppression logic
- fallback usefulness
- no invented proximity or district claims

## CTO / UX Consumption Note

This contract is immediately usable for:

- CTO runtime-payload generation or regeneration work
- UX review of listing section behavior and copy quality

It does not authorize implementation changes by itself. If a future execution issue uses it, that issue should include a `## Copy Handoff` block citing `docs/enrichment/restaurant-listing-enrichment-contract.md`.

## Escalation Check

CTO escalation was unnecessary for this issue.

No field-shape or renderer-contract conflict was discovered.

## Recommended Next Issue

Use this contract in the next restaurant listing regeneration or validation pass that converts a thin or generic restaurant listing payload into the approved template surfaces without changing taxonomy, route structure, or locality authority.
