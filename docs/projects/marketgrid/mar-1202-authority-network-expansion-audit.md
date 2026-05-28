# MAR-1202 Authority-Network Expansion Audit

Status: Delivered
Issue: MAR-1202
Date: 2026-05-27
Owner: CMO

## Scope

Audit whether current MarketGrid authority already covers future internal-link expansion across:

- topical hubs
- common searches
- guide/contextual entry paths
- related authority-flow behavior

This audit is limited to existing authority and thin-slice route coverage. It does not introduce new SEO systems, taxonomy, or implementation work.

## Authority Docs Applied

- Hierarchy: `docs/system/site-architecture.md`
- Taxonomy: `docs/system/category-governance-system.md`
- Common-search generation: `docs/system/common-searches-system.md`
- Research/evidence method: `docs/system/research-core.md`
- Page behavior: `docs/pages/geo-hub-system.md`
- Page behavior: `docs/pages/business-directory-system.md`
- Page behavior: `docs/pages/topical-hub-system.md`
- Page behavior: `docs/pages/category-page-system.md`
- Page realization boundary: `docs/design-system/page-assembly-rules.md`
- Reusable navigation surfaces: `docs/design-system/component-inventory.md`

Breadcrumb and CTA authority were reviewed from the parent packet and did not change the CMO findings here:

- `docs/system/breadcrumb-system.md`
- `docs/system/cta-heirarchy-system.md`

## Repo Surfaces Checked

- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/index.astro`
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/index.astro`
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/[listing]/index.astro`
- route inventory under `apps/astro-ssg-thin-slice/src/pages/`

Current thin-slice runtime only realizes:

- homepage
- state page
- geo hub
- nested category page
- nested listing page

No thin-slice route currently exists for:

- standalone business directory page
- topical hub page
- guide/contextual page

## Demand Validation Notes

All demand-facing findings below were checked against `docs/validators/demand-validation.md`.

| Demand evaluated | Evidence type | Confidence | Result | Reasoning |
| --- | --- | --- | --- | --- |
| Common Searches as modeled search-intent shortcuts | system + proxy | medium | PASS | Canonical system exists, ties phrases to existing categories/geo signals, and explicitly avoids fake volume claims. |
| Topical hubs as future expansion nodes for dense verticals | system | high | PASS | Topical hubs are already canonical in architecture and page contracts when vertical depth justifies them. |
| Guide/contextual pages as future destinations for common-search demand | system only | low | ESCALATE | Guide pages are allowed structurally, but no guide-specific demand or routing authority defines when a query deserves a guide instead of a category or topical hub. |
| Future placeholder destinations inside common searches | system only | low | FAIL for current implementation planning | `common-searches-system.md` allows placeholders, but page-template implementation cannot rely on placeholder destinations without a canonical destination/eligibility rule. |

## Findings

### 7.3 - Prepare for Authority Network Expansion

Status: `partial`

What already exists:

- Site architecture already defines the allowed hierarchy and the minimum connected-system behavior:
  - geo hub -> business directory -> topical hub (optional) -> category -> listing
  - guide pages are secondary and must route into primary pages
  - lateral navigation currently includes related categories, nearby towns, and related listings
- Geo hub authority already reserves a `COMMON SEARCHES` section and ties it to `docs/system/common-searches-system.md`.
- Topical hub authority already exists as a canonical optional layer for dense verticals and explicitly supports high-level service-group queries.
- Category page authority already reserves optional internal links and connects common searches to category-page targets.
- Design-system authority already provides reusable navigation surfaces for:
  - `RelatedLinks`
  - `NearbyGeos`
  - navigation cards for guides, related categories, and directory nodes

What is only partial:

- `docs/system/common-searches-system.md` permits destinations such as `guide / article` and `future content placeholder`, but no canonical authority defines:
  - when modeled intent should resolve to category page vs topical hub vs guide
  - when a placeholder destination is acceptable versus disallowed
  - how future guide/contextual pages feed authority back into category/listing paths
- Site architecture allows guide pages, but there is no matching guide-page contract in `docs/pages/` for:
  - required sections
  - acceptable entry intents
  - required onward links
  - relationship to common searches or related-link modules
- Current lateral-navigation authority is limited to nearby towns, related categories, and related listings. It does not yet define a broader authority-network rule set for:
  - topical hub <-> category cross-link eligibility
  - guide/contextual page <-> category cross-link eligibility
  - authority-preserving escalation from geo-hub intent modeling into deeper page-family links

What is missing:

- A canonical authority doc that names the allowed future authority-network destinations and the eligibility rules between them.
- A canonical rule for converting modeled demand into new internal-link surfaces without inventing unsupported query families.
- A canonical guide/contextual page contract if those pages are expected to become real destinations rather than conceptual placeholders.

Conclusion:

`7.3` is not missing from scratch, but it is not complete enough for deterministic page-template implementation. MarketGrid has the architecture backbone and reusable navigation surfaces, but lacks the final authority layer that governs expansion beyond current geo/category/listing patterns.

### Constraints that should shape 7.2 - Introduce Nearby and Contextual Links

Status: `exists` for base guardrails, `partial` for destination rules

Current guardrails already in authority:

- Lateral links must stay subordinate to the first decision surface and cannot precede the main task surface.
- Nearby/contextual links must preserve URL-faithful hierarchy and cannot invent breadcrumb levels.
- Category pages may link to related categories; geo hubs may link to nearby towns; listing pages may link to related listings.
- Guide pages, if used later, must route into at least one primary page type and must not become dead ends.
- Category naming and category-group expansion must remain canonical and cannot fragment into ad hoc long-tail taxonomy.
- Common Searches may model likely search behavior, but they do not claim exact keyword volume.

Constraints still needed before 7.2 can safely expand beyond the current families:

- A destination-priority rule for contextual links:
  - category page first when the query maps cleanly to existing category intent
  - topical hub only when dense-vertical authority already exists
  - guide/contextual page only after a page contract and demand proof exist
- A rule that nearby/contextual modules cannot use placeholder destinations in implementation-facing artifacts.
- A rule that common-search modeled phrases cannot be treated as proof of a new category, new topical hub, or new guide without a separate demand-validation pass.

## Minimal Gaps To Close Before Page-Template Implementation

1. Add one canonical authority artifact for authority-network expansion.
   It should define allowed destination families, priority order, and cross-link eligibility between geo hub, directory, topical hub, category, listing, and future guide/contextual pages.

2. Either remove or constrain `future content placeholder` from implementation-facing common-search destination rules.
   Current wording is acceptable as ideation language, but it is too loose for deterministic template planning.

3. If guide/contextual pages are intended to become real authority-network nodes, add a matching page contract under `docs/pages/` before implementation begins.

No broader SEO system rewrite is warranted from this audit.

## Exists / Partial / Missing Summary

| Area | Status | Notes |
| --- | --- | --- |
| Architecture-level connected-system rules | exists | Strong hierarchy and dead-end prevention already defined in `site-architecture.md`. |
| Common-search modeling for geo-hub shortcuts | exists | Clear authority exists, but it is modeled intent rather than direct volume proof. |
| Topical-hub role in future expansion | exists | Canonical optional page type already defined. |
| Reusable nearby/related navigation surfaces | exists | UX authority already names `RelatedLinks`, `NearbyGeos`, and navigation cards. |
| `7.3` authority-network expansion policy | partial | Backbone exists; destination-eligibility and authority-flow rules do not. |
| Search-intent rules for contextual/guide destinations | partial | Common searches hints at them, but no canonical routing/eligibility contract exists. |
| Guide/contextual page contract | missing | Architecture allows guide pages, but no `docs/pages/*` contract defines them. |
| Placeholder-destination policy for implementation handoff | missing | Current common-search doc allows placeholders without a deterministic execution boundary. |

## Final Disposition

`done` — audit complete. The current system already supports basic authority-network expansion conceptually, but `7.3` remains `partial` until MarketGrid defines canonical destination-eligibility rules and, if needed, a guide/contextual page contract.
