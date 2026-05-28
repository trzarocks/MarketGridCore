# MAR-1203 Authority-Network Expansion Eligibility Rules

Status: Delivered
Issue: MAR-1203
Date: 2026-05-27
Owner: CMO

## Objective

Define the canonical eligibility policy for authority-network expansion before page-template implementation continues.

This artifact closes the destination-eligibility gap identified in `docs/projects/marketgrid/mar-1202-authority-network-expansion-audit.md` without introducing new page types, taxonomy, or implementation work.

## Authority Packet and Preflight

- Parent Authority Packet: `MAR-1199` comment `369ac0bd-8d67-4075-ac6c-6ff42f5327f6`
- Authority mode: `full`
- Reason for full mode: this issue defines a new authority artifact, which meets the re-run condition in the parent packet

## Authority Docs Applied

- `../docs/system/authority-ingestion-matrix.md`
- `../docs/system/authority-map.md`
- `../docs/system/agent-execution-contract.md`
- `../docs/system/role-based-ingestion-map.md`
- `../docs/system/site-architecture.md`
- `../docs/system/system-map.md`
- `../docs/system/category-governance-system.md`
- `../docs/system/common-searches-system.md`
- `../docs/system/research-core.md`
- `../docs/validators/demand-validation.md`
- `../docs/pages/geo-hub-system.md`
- `../docs/pages/business-directory-system.md`
- `../docs/pages/topical-hub-system.md`
- `../docs/pages/category-page-system.md`
- `docs/projects/marketgrid/mar-1200-linking-breadcrumb-audit.md`
- `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md`
- `docs/projects/marketgrid/mar-1202-authority-network-expansion-audit.md`

## Scope Decision

Guide and contextual pages are out of the current implementation scope.

For the current page-template phase, authority-network expansion may only map into already approved page families and only where the destination is deterministic under current authority. This artifact therefore governs:

- which destination families are eligible now
- which source pages may link to which destination families
- when topical hubs are allowed versus downgraded to category targets
- which proposed destinations must fail instead of flowing into implementation

## Demand Validation Decisions

All demand decisions below were checked against `../docs/validators/demand-validation.md`.

| Demand evaluated | Evidence type | Confidence | Result | Reasoning |
| --- | --- | --- | --- | --- |
| Canonical category-intent demand mapping to category pages | direct + proxy + system | high | PASS | Category pages are the canonical fulfillment layer for service-specific local intent and are already supported by architecture, taxonomy, and page contracts. |
| Business-specific demand mapping to listing pages | direct + system | high | PASS | Listing pages represent named businesses and are valid only when the user intent is entity-specific or the source page is already in related-listing context. |
| Broad vertical demand mapping to topical hubs | system + proxy | medium | PASS with gate | Topical hubs are canonical only when vertical depth is real and a canonical topical-hub route exists for the destination. |
| Common-search phrasing used as proof of a new category, new hub, or new page family | system only | low | FAIL | Modeled phrasing is not sufficient evidence to create new structural demand or taxonomy. |
| Guide/contextual destinations for current implementation-facing mapping | system only | low | FAIL | Architecture allows guide pages in principle, but no guide-page contract or demand proof defines deterministic eligibility in the current phase. |
| Placeholder destinations in implementation-facing artifacts | none | low | FAIL | Placeholder targets are not real demand destinations and cannot be executed safely by CTO or UX. |

## Canonical Destination Families

### 1. Category Page

Default destination for validated local service demand.

Use when:
- the phrase maps cleanly to one canonical category
- the intent is service or category specific
- no intermediate vertical step is required

Examples:
- `emergency plumber in [town]`
- `dentists near [town]`
- `coffee shops in [town]`

### 2. Listing Page

Allowed only for entity-specific or listing-to-listing navigation.

Use when:
- the user intent is clearly about one business
- the source module is a related-listing or featured-provider context already tied to business entities

Do not use listing pages as a substitute for unresolved category or vertical intent.

### 3. Topical Hub

Conditionally allowed, not default.

Use only when all of the following are true:
- the demand is broad vertical intent rather than category-specific intent
- the vertical is already canonical in taxonomy and page authority
- the vertical has enough child-category depth to justify an intermediate layer
- the destination canonical route exists in the active implementation slice

If any gate fails, map to the nearest valid category destination instead of inventing or holding the query for a hub.

### 4. Geo Hub

Allowed for recovery and nearby-place exploration, not as a Common Searches expansion target.

Use when:
- the user is moving to a nearby town
- the page needs a broader parent recovery path

Do not use geo hubs as the destination for category or vertical demand that should resolve deeper.

### 5. Business Directory

Structural page family, but not an authority-expansion destination in the current implementation phase.

Use only as:
- parent context in breadcrumbs or upward navigation where the route exists
- a directory-entry surface already defined by page authority

Do not target business-directory pages or directory slices from Common Searches or contextual demand modules in current implementation artifacts unless the destination route is realized and explicitly approved for that module.

### 6. Guide / Contextual Page

Out of current scope.

Do not map demand to guide or contextual pages in:
- Common Searches
- contextual-link modules
- implementation handoff notes
- route planning for the current template phase

## Destination Priority Rules

Apply this order when choosing a destination family:

1. Listing page when the demand is entity-specific.
2. Category page when the demand maps to one canonical category.
3. Topical hub only when the demand is truly broad vertical intent and every hub gate passes.
4. Geo hub only for nearby-place recovery or broader exploration, never as a substitute for unresolved category demand.
5. Guide/contextual destinations are not eligible in the current phase.

Tie-break rule:
- if a phrase could fit both topical hub and category page, choose category page unless the phrase is clearly vertical-wide and the hub already exists as a realized canonical route

## Cross-Link Eligibility Rules

| Source page | Allowed destination families | Required gate | Not allowed in current phase |
| --- | --- | --- | --- |
| `geo_hub` | business directory, category page, nearby geo hub, topical hub (conditional) | Common Searches must resolve to a real approved destination; nearby links must stay geo-valid | guide/contextual page, placeholder target, invented category/hub |
| `business_directory` | category page, topical hub (conditional), geo hub | topical hub only when dense vertical + canonical route exist | guide/contextual page, placeholder target |
| `topical_hub` | child category page, business directory, geo hub | all outbound links must preserve the vertical-to-category hierarchy | guide/contextual page, placeholder target, unrelated sibling vertical jump |
| `category_page` | listing page, related category page in same geo, nearby same-category page, geo hub, topical hub or directory parent when present in hierarchy | related categories must remain canonical and same-intent; nearby links must keep the same category | guide/contextual page, placeholder target, ad hoc taxonomy branch |
| `listing_page` | parent category page, geo hub, business directory or topical-hub parent when present, related listing page | related listings must remain entity-level and valid | guide/contextual page, placeholder target, category-inventing lateral jump |

## Implementation-Safe Rules

1. No placeholder destinations may appear in any implementation-facing artifact, route plan, module spec, or CTO handoff.
2. Common Searches may model phrasing, but modeled phrasing does not authorize a new category, new topical hub, new guide, or new page family.
3. When a topical hub is authorized in page authority but not realized in the active route slice, implementation must downgrade the destination to the nearest valid category page or keep the node as non-link structural context.
4. UX link modules may render only destinations that resolve to valid approved pages under this policy.
5. This policy does not authorize new taxonomy, new route families, or guide/contextual page work.

## CTO and UX Handoff Note

For the current page-template phase:

- CTO may implement only category, listing, nearby-geo, and hierarchy-preserving parent-context targets that resolve to real approved pages.
- UX may place contextual and nearby modules only with destinations allowed by this policy and by `docs/projects/marketgrid/mar-1201-nearby-contextual-link-placement-contract.md`.
- Any request to send modeled demand into a guide/contextual or placeholder destination must stop and escalate rather than flow into template work.

## Final Disposition

`done` — the authority-network expansion policy is now deterministic for current implementation work:

- category pages are the default demand destination
- topical hubs are conditional and route-gated
- listing pages remain entity-specific
- guide/contextual pages are out of scope
- placeholder destinations are disallowed

## Compliance Note

- Authority mode: `full`
- Authority source: parent packet `MAR-1199` comment `369ac0bd-8d67-4075-ac6c-6ff42f5327f6` plus issue-local full preflight for authority creation
- Role: `CMO`
- Artifact type: authority-network expansion eligibility policy
- Domains covered: hierarchy, demand validation, common-search destination rules, cross-link eligibility, implementation handoff boundary
- Conflicts: none
- Escalation: required only if future work seeks guide/contextual contracts, new taxonomy, or route families outside this policy
