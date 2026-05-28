# MarketGrid Page Assembly Rules

## Purpose

This document defines how approved page sections are assembled from the reusable design-system primitives.

It does not create or change page contracts. Upstream page/system docs still own:
- page purpose
- section order at the product-contract level
- routing
- schema

This file defines the realization rules CTO must follow when assembling Astro pages from the component inventory.

## User Goal

Make every MarketGrid page feel structurally predictable so the user can immediately tell:
- where they are
- what they can do next
- how to move deeper or broader in the hierarchy

## Entry Points

- `geo_hub`
- `directory_category`
- `category_page`
- `listing_page`

## User Flow

1. User enters a page and sees breadcrumb plus hero context.
2. User reaches the first decision surface without passing through long support content.
3. User scans one section at a time using consistent section headers and card systems.
4. User takes the page’s primary forward action or navigates laterally.

## Assembly Rules

### 1. Page Shell Order

Every page must assemble major sections in this outer order:

1. breadcrumb trail
2. hero
3. first decision surface
4. supporting decision or detail surfaces
5. lateral or upward navigation surfaces

Footer and global chrome are outside this contract.

### 2. Wrapper Contract

Each major section after the hero must use:
- `.page-section`
- `.section-shell`
- optional `.section-header`
- `.section-body`

Rules:
- do not place cards directly under the page root
- do not skip `.section-shell`
- do not create one-off wrapper names when an approved wrapper exists

### 3. First Decision Surface Rule

The first post-hero section must be the page’s main decision surface.

Examples:
- `geo_hub`: category or directory navigation surface
- `category_page`: listing surface
- `listing_page`: conversion or business-detail surface

Disallowed:
- long contextual prose before the first decision surface
- featured content before the primary decision surface
- guide or editorial cards before the primary decision surface

### 4. Section Role Rules

#### Decision section
- contains comparison or navigation components
- carries the strongest post-hero emphasis
- must expose a clear next action

#### Detail section
- contains structured support data
- must not outrank the decision section visually

#### Context section
- supports understanding
- remains short and subordinate

#### Lateral navigation section
- contains nearby towns, related categories, or guides
- appears after the page’s core task is supported

### 5. CTA Placement Rules

- Page-level primary CTA appears in the hero or the first decision surface, not both as equal peers.
- Card-level primary CTA appears inside the card and may share destination with whole-card click.
- Secondary CTAs stay inside the same local surface as the primary CTA they support.
- Tertiary navigation remains visually quiet.

### 6. Featured Treatment Rules

- Featured cards may appear only inside or immediately after the main decision surface.
- Featured treatment may elevate a card visually, but it must not alter the information architecture.
- Do not create a standalone featured experience that precedes the standard decision surface.

## Page-Type Realization Rules

### Geo Hub

Required assembly behavior:
- hero establishes place identity
- first decision surface routes into business-directory or category exploration
- supporting sections may include nearby towns or guides only after the main exploration surface

Required data:
- `page_type = geo_hub`
- `title`
- `geo_id`
- linked `geo_name`

States:
- default: hero plus at least one downward navigation surface
- loading: hero and navigation skeletons
- empty: show no-coverage panel plus any available nearby/upward navigation
- error: show page-level error panel with preserved breadcrumb when available
- success: navigation success only

### Directory Category

Required assembly behavior:
- hero establishes the directory grouping context
- first decision surface exposes child category navigation
- related or nearby navigation is secondary

Required data:
- `page_type = directory_category`
- `title`
- `geo_id`
- optional `category_id`

States:
- default: hero plus category-navigation surface
- loading: hero and navigation skeletons
- empty: no categories available panel
- error: localized or page-level error panel
- success: navigation success only

### Category Page

Required assembly behavior:
- hero confirms category plus location
- first decision surface is the listing surface
- optional supporting guidance and lateral navigation follow the listing surface

Required data:
- `page_type = category_page`
- `title`
- `geo_id`
- `category_id`
- one or more valid business-card targets for the default state

States:
- default: listing cards visible immediately after hero
- loading: hero and listing-grid skeletons
- empty: no listings panel with preserved related or nearby navigation when available
- error: page-level or listing-surface error panel
- success: navigation success only

### Listing Page

Required assembly behavior:
- hero identifies the business
- first decision surface exposes conversion and core business details
- supporting sections may include services, hours, related listings, or nearby navigation after the core business surface

Required data:
- `page_type = listing_page`
- `title`
- `business_id`
- `business_name`
- `primary_category`
- `geo_id`

States:
- default: business hero and core detail surface
- loading: hero and detail skeletons
- empty: not valid when `business_id` is missing; treat as error
- error: page-level error panel with preserved upward navigation if available
- success: navigation or contact-action success only

## Data Requirements

### Required Across All Page Types
- `page_id`
- `page_type`
- `slug`
- `title`
- `status`
- `template`
- `source_entities`

### Required For Navigation Integrity
- `geo_id` when the page belongs to a geo context
- `category_id` when the page belongs to a category context
- `business_id` when the page belongs to a business context

### Optional Support Data
- `description`
- `services`
- `features`
- `hours.*`
- `address.*`
- `contact.*`

Fallback behavior:
- If required page identity data is missing, render the page-level error state.
- If optional support sections lack data, omit those sections.
- If the main decision surface lacks its minimum required data, render the page-level or section-level empty state as defined above.

## Edge Cases

- A page may render with partial support data, but never with ambiguous identity.
- If breadcrumbs are partially available, render only valid crumbs and keep the current page label.
- If only one valid action exists, render only that action; do not reserve empty CTA slots.
- If a section would contain zero valid cards after filtering malformed data, replace the full section body with its empty state.

## Implementation Boundary

- CTO may translate these rules into Astro layouts and components.
- CTO may not change page order, schema, or route contracts through realization work.
- If implementation needs data not present in `schema-contract.md`, stop and escalate instead of inventing fields.

## Compliance Note

- Authority mode: packet
- Authority source: `MAR-1192` comment `81221175-9dde-4a48-986b-b06f8ac570b6`
- Role: `UXDesigner`
- Artifact type: page assembly contract
- Domains covered: section order, wrappers, page-type states, assembly constraints
- Conflicts: none
- Escalation: not required
