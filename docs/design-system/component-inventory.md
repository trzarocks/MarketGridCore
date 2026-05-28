# MarketGrid Component Inventory Contract

## Purpose

This document defines the reusable UI primitives CTO must implement for Astro templates.

Each component includes:
- purpose
- required and optional data
- outputs
- states
- non-negotiable behavior rules

## Scope Boundary

This file owns reusable component contracts only.

It does not redefine:
- page entry points
- page-level user flows
- page section order
- global CTA hierarchy rules
- shared schema requirements outside a component's direct inputs

Related authority:
- `docs/design-system/page-assembly-rules.md` owns page shell order, page-type states, and section placement rules
- `docs/design-system/design-system-consistency.md` owns global interaction rules, CTA hierarchy, and shared state behavior
- `docs/system/schema-contract.md` owns canonical field names and entity shapes

## Named Astro Component Mapping For `MAR-1192`

This section is the deterministic bridge between the reusable UX contract in this file and the minimum Astro component inventory named in `MAR-1192`.

Status values:
- `required_now`: canonical and required in the current thin-slice reusable layer
- `conditional_now`: canonical, but only required when the approved page section exists
- `deferred`: canonical name reserved, intentionally not implemented in the current thin slice

| Astro component name | Status | UX contract mapping | User-facing purpose | Required data | Outputs | State contract | Fallback behavior |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `PageShell` | `required_now` | page shell order from `docs/design-system/page-assembly-rules.md` plus breadcrumb trail, hero, empty state panel, and error panel from this file | Give every page a predictable outer structure and preserve onward or upward navigation even when sections fail | `page_id`, `page_type`, `slug`, `title`, `status`, `template`, `source_entities`, plus `geo_id`, `category_id`, or `business_id` when the page context requires them | page-load render, breadcrumb navigation, section rendering, page-level empty/error handling | default: page identity is valid and the shell renders breadcrumb, hero, and approved sections in canonical order; loading: shell reserves breadcrumb, hero, and first section footprint; empty: page-level empty panel replaces the first decision surface when the page has valid identity but no usable primary content; error: page-level error panel renders when required page identity is incomplete or page fetch fails; success: navigation success only, no separate success chrome | if page identity data is incomplete, render page-level error; if a section has no valid content, render the section empty state or omit the optional section without breaking the shell |
| `Breadcrumbs` | `required_now` | direct named realization of the `Breadcrumb Trail` contract below | Expose upward navigation and page context without requiring the user to rebuild hierarchy mentally | `page_type`, `title`, `slug`, `geo_id`, `category_id`, `business_id`, plus `geo_name`, `category_name`, or `business_name` from linked entities when applicable | click breadcrumb item to navigate to the represented parent route | default: full breadcrumb path shown; loading: reserved breadcrumb row skeleton; empty: allowed only when the page has no valid parent path; error: show current page title only; success: navigation success only | missing parent target renders plain text instead of a broken link; if the full parent path is unavailable, preserve the current-page crumb only |
| `Hero` | `required_now` | direct named realization of the `Hero` contract below | Identify the page subject immediately and expose the primary action context | `title`; `geo_name`, `category_name`, or `business_name` as applicable; optional `description`; optional approved CTA targets and support metadata | click primary CTA; click secondary CTA | default: title, support text, and action area render in final layout; loading: hero skeleton with reserved title, metadata, and CTA footprint; empty: valid only when the page subject cannot be formed and the page falls back to page-level empty; error: compact error copy in the hero shell with preserved breadcrumb when available; success: navigation or link invocation success only | if the page subject cannot be formed from required data, the page shell must use the page-level empty or error contract instead of rendering a partial hero |
| `Section` | `required_now` | direct named realization of the canonical section wrapper contract `.page-section > .section-shell > optional .section-header + .section-body` from `docs/design-system/page-assembly-rules.md` | Give every post-hero surface a predictable wrapper so users can scan one section at a time | approved child surface content; optional section title text; optional section description; optional supporting action target | click optional section-header action; child-surface interactions occur inside the section body | default: section wrapper renders in canonical order with any approved header and body; loading: reserved wrapper, header, and body footprint; empty: omit the section only when the parent page contract marks it optional, otherwise render the section empty state inside the wrapper; error: keep the wrapper and header, render an inline error panel in the section body; success: child-surface success only | do not create one-off wrappers; if header data is absent, render body-only within the canonical wrapper; if body content is invalid and the section is optional, omit the section |
| `CTAGroup` | `required_now` | direct named realization of the `CTA Group` contract below | Group one primary path with subordinate actions without creating CTA hierarchy confusion | primary target; optional secondary target; optional tertiary text link | click primary CTA; click secondary CTA; click tertiary link | default: primary first, secondary second, tertiary lowest; loading: preserve button and link footprint; empty: render nothing if no valid targets exist; error: hide the failed target and preserve any remaining valid action; success: navigation or link invocation success only | only one primary action is allowed; remove actions whose required data is missing; never render disabled controls for missing data |
| `HeroStats` | `conditional_now` | hero plus detail-list support rows | Surface high-value supporting metadata in or adjacent to the hero without changing the hero into a card grid | page title context plus at least one complete support item from `address.*`, `contact.*`, `hours.*`, `services`, or `features` | optional click on a support link such as website or phone when present | default: render only complete support items next to the hero context; loading: reserve support-row footprint inside the hero area; empty: omit the module when no complete items exist; error: render only remaining valid rows and omit invalid rows; success: link invocation success only | if no complete support items exist, omit `HeroStats` and keep the hero content-only |
| `TrustPanel` | `conditional_now` | detail list or compact context/support panel inside a detail or context section | Give the user confidence through concrete support facts without competing with the primary CTA | at least one complete label/value pair from `address.*`, `contact.*`, `hours.*`, or other approved page support metadata already present in schema-backed inputs | optional click on linked support values | default: render a labeled support panel with only valid rows; loading: reserve panel title and row footprint; empty: omit the panel when no complete rows exist; error: render only valid rows and suppress broken values; success: link invocation success only | if no valid support rows exist, omit the panel rather than render placeholders |
| `FeaturedCard` | `conditional_now` | direct named realization of the `Featured Card` contract below | Elevate approved featured inventory without changing comparison behavior or information architecture | same required and optional inputs as `Listing Card`; optional featured label text | same as `Listing Card`: click card or primary CTA to listing page; click secondary CTA for call or website when present | default: listing-card structure with featured surface; loading: same footprint as `Listing Card`; empty: omit featured treatment if no featured items exist; error: omit malformed featured item; success: navigation or link invocation success only | same destination and CTA order as `Listing Card`; if featured data is absent, fall back to the standard listing-card treatment rather than invent a new card pattern |
| `InfoCard` | `conditional_now` | explicit alias of `TrustPanel` when implementation chooses a card-like support surface name | Present compact support facts inside a bordered informational surface without creating a new interaction model | at least one complete label/value pair from `address.*`, `contact.*`, `hours.*`, or other approved page support metadata already present in schema-backed inputs | optional click on linked support values | default: labeled support panel with only valid rows; loading: reserve panel title and row footprint; empty: omit the panel when no complete rows exist; error: render only valid rows and suppress broken values; success: link invocation success only | `InfoCard` must behave exactly like `TrustPanel`; if no valid support rows exist, omit the surface rather than render placeholders |
| `CategoryCard` | `conditional_now` | navigation card variant for category exploration | Help the user move from geo or directory context into a specific category path | target `slug`, `category_id`, `category_name`; optional one-line description | click card or inline link to category page | default: card renders label, optional support text, and one category target; loading: card skeleton at final height; empty: invalid for a single card and handled by the parent card set or section empty state; error: omit the malformed card; success: navigation success only | if the target route or label is missing, omit the card; if all cards are invalid, use the parent section empty state |
| `GeoContextCard` | `conditional_now` | navigation card variant for geo-context or local-context movement | Help the user move laterally to a nearby town or local geographic context when the current page cannot fully satisfy intent | target `slug`, `geo_id`, `geo_name`; optional one-line description | click card or inline link to geo target | default: card renders geo label, optional support text, and one geo target; loading: card skeleton at final height; empty: invalid for a single card and handled by the parent card set or section empty state; error: omit the malformed card; success: navigation success only | if no valid geo targets exist, omit the card set or replace the parent section body with the empty state |
| `CTAButton` | `required_now` | CTA group, with tiering rules from `docs/design-system/design-system-consistency.md` | Present the next action with one unambiguous primary path and subordinate secondary/tertiary actions | valid internal target `slug` or relevant entity id; `contact.phone` for call; `contact.website` for external visit | click primary CTA, secondary CTA, or tertiary link | default: render the action when its required target exists and its visual tier is approved by the local surface; loading: reserve button or link footprint without fake labels; empty: omit the action when no valid target exists; error: remove only the failed action and preserve remaining valid actions; success: navigation or link invocation success only | if the required target is missing, remove the affected action; never render a disabled CTA for missing data |
| `FAQBlock` | `deferred` | reserved FAQ section surface; no approved component behavior is required in the current thin slice | Future optional support section for validated FAQ content only after a page contract explicitly includes FAQ | approved FAQ data only when present in runtime contracts; this file does not define new FAQ fields | question expand/collapse or link interaction only if approved by a future page/system contract | default: not rendered in the current thin slice; loading: not rendered; empty: not rendered; error: not rendered; success: not applicable until a future approved contract activates the component | do not implement or render in the current thin slice; omit entirely unless a future approved contract activates it |
| `RelatedLinks` | `conditional_now` | navigation card set or quiet tertiary-link cluster for related categories, guides, or upward/lateral destinations | Prevent dead ends after the main decision surface | at least one valid internal target with `slug` plus display label from `title`, `category_name`, or `geo_name` | click link or card to related destination | default: render one or more valid related destinations after the core task surface; loading: reserve either inline-link or card-set footprint; empty: omit the cluster or render the section empty state when the section is required by the parent contract; error: omit malformed destinations and keep valid ones; success: navigation success only | if no valid related destinations exist, omit the optional cluster or use the parent section empty state when the section itself is required |
| `NearbyGeos` | `conditional_now` | specialized geo-context navigation set built from navigation cards | Give the user a nearby-place escape hatch when local coverage is thin or when nearby exploration is useful | one or more valid targets using `geo_id`, `geo_name`, and target `slug` | click nearby-geo destination | default: render a nearby-geo set using valid geo targets only; loading: reserve the nearby-geo card-set footprint; empty: omit the section when no valid targets exist; error: drop malformed geo targets and keep valid ones; success: navigation success only | if the set is empty or invalid, do not render the section |
| `SourceNote` | `deferred` | reserved provenance surface; current UX contracts use source grounding for data integrity, not as a required user-facing section | Future optional note for explaining factual grounding without turning the product into an editorial document surface | if activated later, it must use already-approved source fields such as `source.source_name`, `source.source_url`, and `source.retrieved_at` | optional click to source URL only when approved by a future contract | default: not rendered in the current thin slice; loading: not rendered; empty: not rendered; error: not rendered; success: not applicable until a future approved contract activates the component | do not add a user-facing source section in the current thin slice |

### Mapping Rules

- The names above are canonical Astro realization names for `MAR-1192` close-out.
- A named Astro component may be realized as a standalone file or as a constrained subcomponent inside a canonical parent component, but the mapped UX behavior may not change.
- `required_now` components are mandatory for the reusable thin-slice foundation.
- `conditional_now` components must exist only when the approved page section exists in upstream page/system contracts.
- `deferred` components are intentionally out of the current thin slice and must not be added opportunistically during reusable-layer implementation.

## Component Definitions

### 1. Breadcrumb Trail

Purpose:
- expose upward navigation and page context

Inputs:
- `page_type`
- `title`
- `slug`
- `geo_id`
- `category_id`
- `business_id`
- `geo_name`, `category_name`, and `business_name` from linked entities where applicable

Outputs:
- click breadcrumb item -> navigate to represented parent route

States:
- default: full breadcrumb path shown
- loading: reserved breadcrumb row skeleton
- empty: allowed only when the page has no valid parent path
- error: show current page title only
- success: not applicable beyond navigation

Rules:
- current page crumb is not clickable
- no inferred fallback URLs
- missing parent target renders plain text, not a broken link

### 2. Hero

Purpose:
- identify page subject and expose the primary action context

Inputs:
- `title`
- `geo_name`, `category_name`, or `business_name` as applicable
- optional `description`
- optional key metadata
- optional CTA targets

Outputs:
- click primary CTA
- click secondary CTA

States:
- default: title, support text, and action area render in final layout
- loading: hero skeleton with reserved title, metadata, and CTA footprint
- empty: only valid when the page subject cannot be formed; page should fall back to page-level empty
- error: compact error copy in hero shell with preserved breadcrumb if available
- success: not applicable beyond navigation

Rules:
- hero is the highest-importance section
- hero may use the strongest visual treatment
- hero must not contain comparison grids or listing cards

### 3. Section Header

Purpose:
- anchor each major section and explain what follows

Inputs:
- section title text
- optional section description
- optional supporting action target

Outputs:
- click optional section action

States:
- default: title and optional supporting elements render
- loading: reserved header footprint
- empty: header omitted when the full section is omitted
- error: section title may remain with inline error panel below
- success: not applicable

Rules:
- use before every major section after the hero
- right-side action is optional and subordinate

### 4. CTA Group

Purpose:
- group primary and secondary actions without hierarchy confusion

Inputs:
- primary target
- optional secondary target
- optional tertiary text link

Outputs:
- click primary CTA
- click secondary CTA
- click tertiary link

States:
- default: primary first, secondary second, tertiary lowest
- loading: preserve button/link footprint
- empty: render nothing if no valid targets exist
- error: hide failed target and preserve any remaining valid action
- success: not applicable beyond navigation

Rules:
- only one primary action in the group
- do not render disabled buttons for missing data

### 5. Listing Card

Purpose:
- support business comparison and provider selection

Required inputs:
- `business_id`
- `business_name`
- `primary_category`
- `slug`
- `status`

Optional inputs:
- `description`
- `services`
- `features`
- `address.city`
- `address.state`
- `contact.phone`
- `contact.website`

Outputs:
- click card or primary CTA -> listing page
- click secondary CTA -> call or external website

States:
- default: full card layout
- loading: card skeleton at final card height
- empty: not rendered individually; page-level empty handles zero-result state
- error: omit malformed card and preserve the grid if other cards remain
- success: not applicable beyond navigation

Rules:
- whole-card click and primary CTA target must match
- secondary CTA renders only when data exists
- descriptions are capped to short support text

### 6. Featured Card

Purpose:
- present approved featured inventory without breaking comparison trust

Required inputs:
- same as listing card

Optional inputs:
- featured label text

Outputs:
- same as listing card

States:
- default: listing-card structure with featured surface
- loading: same footprint as listing card
- empty: omit featured band if no featured items exist
- error: omit malformed featured item
- success: not applicable beyond navigation

Rules:
- same structure and CTA order as listing card
- featured treatment is visual emphasis only, not a new interaction model

### 7. Navigation Card

Purpose:
- support lateral or upward navigation to nearby towns, related categories, guides, or directory nodes

Required inputs:
- target `slug`
- one subject label from `geo_name`, `category_name`, or `title`

Optional inputs:
- one-line support description

Outputs:
- click card or inline link -> navigate to target

States:
- default: label plus concise explanation
- loading: card skeleton
- empty: omit the section or card set if no valid targets exist
- error: omit malformed card
- success: not applicable beyond navigation

Rules:
- each card must answer why the user should click
- no decorative metadata rows

### 8. Detail List

Purpose:
- present structured business or page support data

Required inputs:
- at least one complete label/value pair from address, hours, contact, or metadata fields

Outputs:
- optional link click inside a value

States:
- default: labeled list of available values
- loading: reserved rows
- empty: omit the detail list if no complete pairs exist
- error: render only valid pairs
- success: not applicable

Rules:
- hide rows with missing values
- do not render placeholder labels with empty values

### 9. Empty State Panel

Purpose:
- explain unavailable data without creating a dead end

Inputs:
- page or section context label
- optional upward or lateral navigation target

Outputs:
- click fallback navigation target

States:
- default: explanatory empty panel
- loading: not applicable
- empty: not applicable
- error: not applicable
- success: not applicable

Rules:
- use neutral styling
- include a next path when a valid alternative exists

### 10. Error Panel

Purpose:
- communicate section or page failure while preserving the rest of the page where possible

Inputs:
- failure context label
- optional recovery navigation target

Outputs:
- click recovery navigation target

States:
- default: visible when a failure occurs
- loading: not applicable
- empty: not applicable
- error: this is the error state artifact
- success: not applicable

Rules:
- compact and localized
- does not replace unaffected sections

## Shared Data Rules

- Use canonical schema fields only.
- Unknown values remain `null`.
- Missing optional values remove the dependent element.
- Missing required navigation targets remove the clickable behavior.

## Edge Cases

- Closed or unknown-status businesses may still render if page authority permits them, but status must not be hidden from implementation logic.
- Partial address data may render as city/state only.
- A card set with one valid card and several invalid cards still renders with the valid card(s).

## Compliance Note

- Authority mode: packet
- Authority source: `MAR-1192` comment `81221175-9dde-4a48-986b-b06f8ac570b6`
- Role: `UXDesigner`
- Artifact type: reusable component inventory
- Domains covered: reusable primitives, inputs, outputs, states, edge cases
- Conflicts: none
- Escalation: not required
