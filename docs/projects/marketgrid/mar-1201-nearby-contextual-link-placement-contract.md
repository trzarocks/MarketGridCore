# MAR-1201 Nearby and Contextual Link Placement Contract

Status: Delivered
Issue: MAR-1201
Date: 2026-05-27
Owner: UXDesigner

## Authority Packet Used

- Parent Authority Packet: `MAR-1199` comment `369ac0bd-8d67-4075-ac6c-6ff42f5327f6`
- Authority mode: `full`
- Role scope: nearby, contextual, and upward link placement and flow

## Audit Finding

Finding: `partial`

- `exists`: upstream authority already requires upward, lateral, and onward navigation in `docs/system/site-architecture.md`
- `exists`: upstream authority already fixes the first-decision-surface rule and places lateral navigation after core task support in `docs/design-system/page-assembly-rules.md`
- `exists`: reusable components already exist for `Breadcrumbs`, `RelatedLinks`, and `NearbyGeos` in `docs/design-system/component-inventory.md`
- `missing`: current authority does not yet define one deterministic page-by-page placement contract for when nearby and contextual links appear, in what order they appear, and how they collapse in empty or error states

This artifact closes the `missing` gap without changing upstream authority.

## User Goal

Help the user recover from a dead end or continue exploration without losing context.

From the user perspective, link behavior must answer one of three needs:

1. Go back to a broader parent context.
2. Switch to a closely related option in the same task context.
3. Move to a nearby place when the current place is too narrow or has weak coverage.

## Entry Points

- `geo_hub`
- `directory_category`
- `category_page`
- `listing_page`

`topical_hub` behavior is included where the route exists inside the breadcrumb chain or page hierarchy.

## Link Types Covered

### 1. Upward Links

Purpose:
- move the user to broader context

Allowed destinations:
- geo hub
- business directory text node in breadcrumb when present in URL structure
- topical hub when present in URL structure
- parent category page

Primary component:
- `Breadcrumbs`

### 2. Contextual Links

Purpose:
- keep the user in the same decision space

Allowed destinations:
- related category pages in the same geo
- parent category page from listing pages
- topical hub or directory context when present in the hierarchy
- guide or directory destinations only when already approved by page authority

Primary component:
- `RelatedLinks`

### 3. Nearby Links

Purpose:
- give the user a nearby-place escape hatch when local coverage is thin or when adjacent-town comparison is useful

Allowed destinations:
- nearby `geo_hub` pages
- nearby same-category `category_page` pages

Primary component:
- `NearbyGeos`

## Global Placement Rules

### Rule 1. Upward navigation is always first in page order

- `Breadcrumbs` render above the hero on every page that has a valid parent path.
- `Breadcrumbs` are the only allowed upward-link cluster before the first decision surface.
- No nearby or related-link section may appear above the hero or between the hero and the first decision surface.

### Rule 2. First decision surface keeps priority

- `geo_hub`: first decision surface is town-to-directory or town-to-category exploration.
- `directory_category`: first decision surface is child-category exploration.
- `topical_hub`: first decision surface is child-category exploration.
- `category_page`: first decision surface is the listing surface.
- `listing_page`: first decision surface is business conversion and core business detail.

Nearby and contextual link clusters may only appear after that page’s first decision surface.

### Rule 3. Contextual links appear before nearby links

When both link types exist on the same page:

1. render contextual links first
2. render nearby links second

Reason:
- related same-task choices are closer to the user’s current intent than location expansion

### Rule 4. Empty states may inline escape navigation

If the main decision surface is empty:

- preserve `Breadcrumbs` when valid
- allow the empty-state panel to include one valid fallback path
- if contextual links exist, show them before nearby links
- if only nearby links exist, show nearby links as the fallback path

### Rule 5. Error states preserve only valid recovery paths

If a section or page errors:

- preserve `Breadcrumbs` when page identity remains valid
- remove malformed related or nearby targets individually
- do not render disabled or placeholder links
- if no valid recovery destination remains, show the error state without a broken navigation module

## Data Requirements

### Current Page Identity

Required on every page:

- `page_id`
- `page_type`
- `slug`
- `title`
- `status`
- `template`
- `source_entities`

Required by page context:

- `geo_id` for geo-scoped pages
- `category_id` for category-scoped pages
- `business_id` for listing pages

Linked entity fields used for labels and context:

- `geo_name`
- `category_name`
- `business_name`
- `primary_category`
- `description`

### Destination Page Data

Every renderable nearby or contextual target must resolve to a valid destination `Page` entity using existing schema-contract fields:

- `page_id`
- `page_type`
- `slug`
- `title`
- `geo_id` when geo-scoped
- `category_id` when category-scoped
- `business_id` when listing-scoped
- `status`

Linked destination entities supply labels:

- nearby geo targets use linked `Geo.geo_name`
- related category targets use linked `Category.category_name`
- listing or business targets use linked `Business.business_name`

### Schema Gap That CTO Must Not Invent Around

`docs/system/schema-contract.md` does not define canonical relationship-set fields for:

- nearby geo collections
- related category collections
- related page collections

Therefore this contract does **not** authorize new persistent field names for those sets.

Implementation rule:

- route generation or loader logic may assemble nearby/contextual target arrays from existing `Page`, `Geo`, `Category`, and `Business` entities
- Astro templates may consume those assembled targets
- CTO must not add a new canonical schema field unless schema authority is separately approved

## Page Contracts

### Geo Hub

### User Flow

1. User lands on a `geo_hub`.
2. User reads place identity in the hero.
3. User reaches the first decision surface: business-directory or category exploration.
4. After that exploration surface, the system may offer nearby geo navigation.
5. User chooses either a local path first or a nearby-town path second.

### Core Interactions

- Trigger: user clicks a category or directory destination in the first decision surface.
  - System response: navigate to the selected local page.
  - Data required: target `Page.slug`, `Page.page_type`, target `geo_id` or `category_id`, display `title`.
  - Resulting state: `success`

- Trigger: user clicks a nearby geo target in the nearby section.
  - System response: navigate to the nearby `geo_hub`.
  - Data required: destination `Page.slug`, destination `Page.page_type = geo_hub`, linked `Geo.geo_name`, destination `geo_id`.
  - Resulting state: `success`

### States

- `default`: hero plus local exploration surface; nearby section appears only after the local exploration surface and only when at least one valid nearby geo target exists
- `loading`: hero skeleton, local exploration skeleton, nearby section footprint reserved only if nearby data is expected
- `empty`: no-coverage panel replaces the local exploration surface; include one valid contextual path if available, otherwise include nearby geo fallback when available
- `error`: page-level error panel with preserved breadcrumb when valid; omit malformed nearby targets
- `success`: user navigates to selected local or nearby destination

### Data Requirements

Required:

- current page identity fields
- linked `Geo.geo_name`
- at least one valid local exploration target for `default`

Optional:

- one or more nearby `geo_hub` destination pages

Fallback behavior:

- if nearby targets are missing, omit the nearby section
- if local exploration is empty but nearby targets exist, show nearby navigation below the empty-state panel

### Edge Cases

- do not render nearby links above local exploration
- do not link to the current geo as a nearby target
- if only one nearby target survives validation, render one valid target only

### Directory Category and Topical Hub

### User Flow

1. User lands on a directory grouping page.
2. User confirms hierarchy through `Breadcrumbs` and hero.
3. User reaches child-category exploration immediately.
4. No dedicated nearby section is rendered in MVP.
5. User exits through child categories or breadcrumb hierarchy.

### Core Interactions

- Trigger: user clicks a child category destination.
  - System response: navigate to the child category page.
  - Data required: destination `Page.slug`, destination `category_id`, display `title` or linked `Category.category_name`.
  - Resulting state: `success`

### States

- `default`: hero plus child-category exploration only
- `loading`: hero and category-navigation skeletons
- `empty`: no categories available panel
- `error`: localized or page-level error panel with preserved breadcrumb when valid
- `success`: navigation success only

### Data Requirements

Required:

- current page identity fields
- one or more valid child category destination pages for `default`

Optional:

- none for dedicated nearby or related-link clusters in MVP

Fallback behavior:

- no dedicated nearby or contextual section is rendered outside the main category-navigation surface

### Edge Cases

- do not append a secondary nearby section to directory or topical pages in MVP
- contextual movement on these pages is satisfied by breadcrumb hierarchy plus the child-category surface itself

### Category Page

### User Flow

1. User lands on a `category_page`.
2. User confirms category plus location in the hero.
3. User reaches listing cards immediately after the hero.
4. After listings, the system may show contextual links to related categories in the same geo.
5. After contextual links, the system may show nearby same-category geo links.
6. User either goes deeper to a listing, laterally to a related category, or outward to the same category in a nearby geo.

### Core Interactions

- Trigger: user clicks a listing card or listing CTA.
  - System response: navigate to the listing page.
  - Data required: destination `Page.slug`, destination `business_id`, linked `Business.business_name`.
  - Resulting state: `success`

- Trigger: user clicks a related category target.
  - System response: navigate to a related `category_page` in the same geo.
  - Data required: destination `Page.slug`, destination `page_type = category_page`, destination `category_id`, destination `geo_id`, linked `Category.category_name`.
  - Resulting state: `success`

- Trigger: user clicks a nearby geo target.
  - System response: navigate to the same category in a nearby geo.
  - Data required: destination `Page.slug`, destination `page_type = category_page`, destination `category_id`, destination `geo_id`, linked `Geo.geo_name`.
  - Resulting state: `success`

### States

- `default`: hero, listing surface, optional contextual section, optional nearby section; contextual appears before nearby when both exist
- `loading`: hero and listing-grid skeletons; defer related and nearby sections until listing load resolves or target data arrives
- `empty`: no-listings panel replaces the listing surface; preserve breadcrumb; show related categories first when valid, then nearby same-category links when valid
- `error`: page-level or listing-surface error panel; preserve breadcrumb and any independently valid recovery navigation
- `success`: user navigates to listing, related category, or nearby same-category page

### Data Requirements

Required:

- current page identity fields
- current `geo_id`
- current `category_id`
- one or more valid listing targets for `default`

Optional:

- one or more same-geo related `category_page` targets
- one or more nearby same-category `category_page` targets

Fallback behavior:

- if related targets are missing, omit the contextual section
- if nearby targets are missing, omit the nearby section
- if listings are empty but nearby same-category targets exist, show nearby section after the empty-state panel

### Edge Cases

- do not render nearby same-category links above the listings
- do not render related-category links that point back to the current page
- if a nearby target has the same `geo_id` as the current page, drop it as invalid
- if a target page is unpublished or missing `slug`, drop it

### Listing Page

### User Flow

1. User lands on a `listing_page`.
2. User sees the business identity and immediate action context.
3. User reaches conversion and core business detail before any navigation cluster.
4. After the `ACTION PANEL`, the system renders the related-link section.
5. Inside that related-link section, the system offers parent and same-task contextual exits first.
6. Nearby geo expansion appears only after those contextual exits and only when valid nearby category destinations exist.

### Core Interactions

- Trigger: user clicks the primary or secondary CTA in the hero or action panel.
  - System response: invoke call or website action.
  - Data required: `contact.phone` for call, `contact.website` for website.
  - Resulting state: `success`

- Trigger: user clicks the parent category page target.
  - System response: navigate to the parent `category_page`.
  - Data required: destination `Page.slug`, destination `category_id`, destination `geo_id`, linked `Category.category_name`.
  - Resulting state: `success`

- Trigger: user clicks a related category target.
  - System response: navigate to a same-geo related `category_page`.
  - Data required: destination `Page.slug`, destination `category_id`, destination `geo_id`, linked `Category.category_name`.
  - Resulting state: `success`

- Trigger: user clicks a nearby geo target.
  - System response: navigate to a nearby same-category `category_page`, not directly to another listing.
  - Data required: destination `Page.slug`, destination `page_type = category_page`, destination `category_id`, destination `geo_id`, linked `Geo.geo_name`.
  - Resulting state: `success`

### States

- `default`: hero, detail surfaces, action panel, then related-link section; parent category and same-task contextual exits appear before nearby expansion
- `loading`: hero and detail skeletons; related-link section footprint reserves only when target data is expected
- `empty`: not valid when `business_id` is missing; treat as `error`
- `error`: page-level error panel with preserved breadcrumb and any valid upward navigation
- `success`: contact action or navigation success only

### Data Requirements

Required:

- current page identity fields
- `business_id`
- `business_name`
- `primary_category`
- `geo_id`
- parent category destination page

Optional:

- related same-geo category-page targets
- nearby same-category category-page targets
- `contact.phone`
- `contact.website`

Fallback behavior:

- if parent category destination is invalid, breadcrumb remains the required upward path and the related-link section omits that item
- if related same-geo category targets are missing, show only any remaining valid nearby section
- if all related and nearby targets are missing, omit the entire related-link section

### Edge Cases

- do not render nearby links before the action panel
- do not link from a listing page directly to a nearby listing page in MVP
- when both `contact.phone` and `contact.website` are missing, remove those CTAs and keep only navigation-based exits

## Component Placement Summary

### `Breadcrumbs`

- placement: always above hero
- pages: all page types when valid parent path exists
- state rule: if parent target is invalid, render plain text for that crumb instead of a broken link

### `RelatedLinks`

- placement: after the first decision surface
- pages: `category_page`, `listing_page`
- order inside the section:
  1. parent category or directory/topical context when applicable
  2. same-geo related category targets
  3. other approved contextual destinations

### `NearbyGeos`

- placement:
  - `geo_hub`: after local exploration
  - `category_page`: after `RelatedLinks`
  - `listing_page`: after parent and related category exits inside the related-link section
- pages not rendering a dedicated nearby section in MVP:
  - `directory_category`
  - `topical_hub`

## Friction Points

- current schema authority does not define canonical relationship collections for nearby or related targets, so data assembly responsibility stays in route-generation or loader logic
- listing-page authority allows nearby navigation but does not specify direct listing-to-listing movement; this contract constrains nearby expansion to nearby same-category category pages in MVP to avoid injecting unsupported ranking logic

## Open Questions / Risks

- If MarketGrid wants canonical persistence for nearby or related target sets, that requires a separate schema-contract change
- If directory or topical pages later require dedicated nearby sections, that needs an upstream page-contract change before implementation

## Final Disposition

`done` — nearby, contextual, and upward link placement is now defined in one implementation-ready UX contract with explicit states, data requirements, ordering, and fallback behavior.
