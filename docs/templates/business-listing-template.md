# MarketGrid Business Listing Template

## Purpose
Define the reusable, approved listing-page template pattern for MarketGrid business listing pages.

This template is the decision layer. It converts category-level comparison intent into business-level action while preserving in-system navigation.

## Scope
Applies to listing pages at route shape `/{town}/{category}/{business}/`.

This document preserves system behavior only. It does not redesign the template and does not rewrite category/geo copy.

## Visual Authority
For static prototype visual direction, `docs/templates/business-directory-universal.html` is the current authority.

Runtime JSON is content input, not visual authority.

## Approved Layout Pattern
- Desktop: two-column hero.
- Hero left column: business identity and summary context.
- Hero right column: Quick Info + primary action block.
- Mobile: stacked order with identity first, then Quick Info/action.

## Required Section Order
1. Hero
2. What They Do (conditional)
3. Good For
4. When This Fits
5. Local Context
6. Back Navigation

Notes:
- Do not render a duplicate lower Action Panel when hero Quick Info already contains primary CTA.
- Related/back links must avoid duplicate equivalents.

## Required Labels
- `What They Do`
- `Good For`
- `When This Fits`
- `Local Context`
- `Visit Website` for website row label
- `Back to {Category}` for secondary upward navigation

## Canonical Runtime Field Mapping
- `breadcrumb` -> breadcrumb display
- `hero.business_name` -> listing `h1`
- `hero.category` -> eyebrow/category context
- `hero.location` -> location/context chip
- `hero.description` -> hero summary
- `quick_info.phone` -> Quick Info phone row and call CTA support
- `quick_info.website` -> website row rendered as `Visit Website`
- `quick_info.address` -> address row
- `what_they_do.summary` -> `What They Do` only when materially different from `hero.description`
- `services_capabilities.items` -> `Good For`
- `when_to_use.items` -> `When This Fits`
- `context_local_fit.items` -> `Local Context`
- `action_panel.primary_ctas` -> hero Quick Info primary CTA
- `related_links.category_page` / `footer_nav.up` -> secondary `Back to {Category}` navigation

## Hero Chip Rules
Hero chips and `Good For` must remain semantically separate.

- Hero chips: location + locality/context cues.
- `Good For`: services/capabilities/use-case tags.

Do not duplicate `Good For` values into hero chips.

Approved chip examples:
- `Salisbury, MD` + `Downtown plan`
- `Salisbury, MD` + `Citywide option`
- `Salisbury, MD` + `Corridor stop`
- `Salisbury, MD` + `Campus-day context`

Disallowed system-shaped labels in user-facing chip copy:
- `Corridor-practical`
- `Fallback`
- `Subgeo`
- `Overlay`

## Suppression and Null Handling Rules
- Suppress `What They Do` when `what_they_do.summary` is identical or near-identical to `hero.description`.
- Do not render duplicate lower Action Panel when CTA is already in hero Quick Info.
- Do not render multiple equivalent Back/Related/Footer links.
- Hide website row when website is null or empty.
- Hide phone CTA when phone/CTA is unavailable.
- Hide empty sections.
- Never render `null`, `undefined`, raw JSON, internal field names, or debug/state labels.

## Navigation Rules
- Breadcrumbs must be URL-faithful.
- Exactly one primary CTA.
- Listing page must provide upward navigation to category and onward path to geo context.
- Back navigation should use one clear secondary `Back to {Category}` control.

## Local Context Treatment
`Local Context` uses secondary panel treatment to provide trust and fit context without competing with the primary action.

## Proof Case Reference (Non-Binding Scope)
Salisbury restaurant slice is the evidence case for this system pattern.
It is proof, not system scope.
