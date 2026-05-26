# Listing Renderer Governance

## Purpose
Define canonical renderer governance for MarketGrid listing-template workflows and prevent divergent renderer confusion.

## Canonical Renderer Concept
For any listing-template workflow, one canonical renderer path must be designated and used for generation.

Agents must not create one-off alternate renderers when a canonical renderer exists and satisfies scope.

## Canonical Identification Requirements
Each listing-template delivery must explicitly record:
- canonical renderer command/path,
- canonical template authority path,
- output artifact directory,
- issue identifier tied to the generation pass.

## Divergent Renderer Prevention Rules
- Do not run a secondary renderer for the same template pass unless a blocker is documented and approved.
- If an experimental renderer exists, mark it deprecated for production/proof pass use or make it delegate to canonical flow.
- Do not mix outputs from multiple renderer paths in one acceptance set.

## Salisbury Lesson (MAR-1069 Evidence)
Evidence from Salisbury prototype correction:
- Successful outputs were produced from the canonical MAR-1069 renderer path.
- A failed Market Street output came from a divergent renderer path.
- Correction required regeneration from canonical path and reaffirmed that multiple active renderer paths for the same pass create drift.

System rule derived from this lesson:
- one template pass -> one canonical renderer path.

## Template Behavior Contract To Enforce
Canonical renderer outputs must preserve:
- two-column hero and right-side Quick Info/CTA card,
- hero chip and `Good For` separation,
- conditional suppression of duplicate `What They Do`,
- `When This Fits` from `when_to_use.items`,
- `Local Context` secondary panel treatment,
- no duplicate lower Action Panel,
- no debug/state/internal-contract UI,
- website displayed as `Visit Website`.

## Future Project Consumption Order
Before creating or modifying listing-page renderers, load in this order:
1. `docs/templates/business-listing-template.md`
2. `docs/design-system/DESIGN.md`
3. `docs/templates/business-directory-universal.html`
4. `docs/runtime/rendering/listing-renderer-governance.md`

Then verify page/system compliance against:
- `docs/system/system-map.md`
- `docs/system/site-architecture.md`
- `docs/system/agent-execution-contract.md`
- `docs/system/breadcrumb-system.md`
- `docs/system/cta-heirarchy-system.md`

## Escalation
If canonical renderer artifacts are not accessible from the assigned workspace, stop and file a blocker with:
- missing artifact/path,
- unblock owner,
- explicit unblock action.
