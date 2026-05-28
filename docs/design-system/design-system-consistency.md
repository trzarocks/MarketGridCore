# MarketGrid Design-System Consistency Contract

## Purpose

This document is the canonical UX contract for reusable MarketGrid Astro template realization.

It defines:
- design tokens and role mapping
- typography and text-role rules
- spacing and container rules
- CTA hierarchy
- card-variant rules
- cross-page interaction and state behavior

It does not define full page templates, routing, schema changes, or one-off component behavior.

## Authority Status

- Active authority for design-system consistency: this file
- Related authority for reusable primitives: `docs/design-system/component-inventory.md`
- Related authority for section composition: `docs/design-system/page-assembly-rules.md`
- Legacy preservation note: `docs/design-system/DESIGN.md`

`DESIGN.md` is narrowed to prototype-preservation context only. CTO must use this file plus the two related contract files for implementation.

## User Goal

Help a user scan a MarketGrid page quickly, understand what the page is about, identify the single primary next action, and move to a more specific result without visual ambiguity.

## Entry Points

- direct landing on a `geo_hub` page
- direct landing on a `category_page`
- direct landing on a `listing_page`
- navigation from internal breadcrumbs
- navigation from related category, nearby town, directory, or listing cards

## User Flow

1. User lands on a page and identifies page subject from the hero.
2. User confirms context from breadcrumb, page title, and support metadata.
3. User scans the first decision surface.
4. User selects the primary CTA or a comparison card.
5. System moves the user deeper into the hierarchy or into a provider profile.

## Core Interactions

### Interaction: breadcrumb navigation
- Trigger: user clicks a non-current breadcrumb item.
- System response: navigate to the exact represented parent page.
- Data required:
  - `page_type`
  - `slug`
  - `title`
  - `geo_id`
  - `category_id`
  - `business_id`
- Resulting state: next page default state.
- Rule: breadcrumbs must be URL-faithful and must not point to inferred fallback routes.

### Interaction: primary CTA
- Trigger: user clicks the highest-priority action on the page or card.
- System response: navigate to the page’s primary next step.
- Data required:
  - `page_type`
  - `slug`
  - one of `geo_id`, `category_id`, or `business_id`
- Resulting state: next page default state.
- Rule: each page surface gets one primary CTA path. Multiple visually equal primary CTAs are not allowed.

### Interaction: secondary CTA
- Trigger: user clicks a lower-priority supporting action.
- System response: perform the supporting action without competing with the primary CTA.
- Data required:
  - `contact.phone` for call
  - `contact.website` for external visit
  - `slug` or target entity ids for internal secondary navigation
- Resulting state: external navigation or next page default state.
- Rule: if required contact data is `null`, hide the secondary CTA instead of rendering a disabled control.

### Interaction: card navigation
- Trigger: user clicks a listing card, related category card, nearby town card, or link CTA inside the card.
- System response: navigate to the linked detail or next-level page.
- Data required:
  - card target `slug`
  - relevant `business_id`, `geo_id`, or `category_id`
  - display label from `business_name`, `geo_name`, or `category_name`
- Resulting state: next page default state.
- Rule: whole-card click and primary CTA click must resolve to the same destination when both exist.

## Global States

These states apply to every page-level surface and every reusable component named in the component inventory.

### Default
- Required data is present.
- Component renders its standard layout.
- Primary CTA is visible when the required target exists.

### Loading
- Render skeleton or placeholder structure using the final layout footprint.
- Do not shift section order during load completion.
- Do not show fake values.

### Empty
- Render a neutral empty-state panel inside the expected section wrapper.
- Explain what is unavailable.
- Preserve upward or lateral navigation where possible.
- Do not render decorative filler to mask missing core data.

### Error
- Render a compact error panel inside the affected section or page shell.
- Preserve available navigation out of the failed state.
- Do not collapse the full page into a blank surface.

### Success
- Used only after a user-triggered action that has a completion outcome beyond navigation.
- For current MVP surfaces, success generally means successful navigation or successful link invocation.
- Do not introduce success toasts or banners unless a real non-navigation completion state exists.

## Data Requirements

### Required Page Context
- `page_id`
- `page_type`
- `slug`
- `title`
- `status`
- `template`
- `source_entities`

### Required Hierarchy Context
- `geo_id` for `geo_hub`, `category_page`, and `listing_page`
- `category_id` for `category_page`
- `business_id` for `listing_page`

### Required Entity Display Data
- `geo_name` from the linked geo entity
- `category_name` from the linked category entity
- `business_name` for listing-based cards and listing pages

### Required Contact Data For Contact Actions
- `contact.phone` for call CTA
- `contact.website` for website CTA

### Optional Display Data
- `description`
- `services`
- `features`
- `hours.*`
- `address.*`
- `social_profiles.*`

### Fallback Rules
- If a required route target is missing, remove the action that depends on it.
- If optional text fields are missing, omit the element instead of substituting invented copy.
- If optional metadata is partially present, render only complete items.
- If no business set exists for a listing surface, show the empty state instead of placeholder cards.

## Token Contract

### Color Roles

Use role names in implementation. Do not hard-code component-specific colors outside the token layer.

| Role | Token | Usage |
|---|---|---|
| page background | `--bg` | full-page background only |
| primary surface | `--surface` | cards, shells, hero panels |
| secondary surface | `--surface-soft` | soft inset panels, contextual blocks |
| featured surface | `--surface-featured` | featured cards or featured bands only |
| primary text | `--text` | headlines and body |
| muted text | `--muted` | support copy and metadata |
| default border | `--line` | default card and section borders |
| emphasized border | `--line-strong` | active or featured borders |
| Maryland gold | `--accent-gold` | warmth, badges, subtle highlights |
| strong gold | `--accent-strong` | badge text and warm emphasis |
| Maryland red | `--accent-red` | links, primary actions, active states |
| strong red | `--accent-red-strong` | hover and pressed states |
| soft red | `--accent-red-soft` | hover wash or selected background accents |

### Color Rules
- Default all non-interactive surfaces to neutral tokens.
- Use Maryland red only for interactive emphasis.
- Use Maryland gold only for warmth, featured treatment, or badges.
- Do not use red as a large page or card background.
- Do not place strong red and strong gold as equal competing signals in the same component.

## Typography Contract

### Text Roles

| Role | Use | Rules |
|---|---|---|
| page title | page `h1` | one per page, strongest hierarchy |
| section title | major section anchor | must be visually below `h1` and above card titles |
| card title | card subject | one concise subject line |
| eyebrow / label | metadata label | uppercase or small-label treatment only |
| body | explanatory text | short, readable, subordinate to structure |
| metadata | address, hours, qualifiers | visually quiet |

### Typography Rules
- Headings use tighter tracking than body text.
- Eyebrows and labels use positive tracking and reduced size.
- Body copy must stay concise and subordinate to listings and actions.
- Typography may scale responsively, but hierarchy order must remain unchanged across breakpoints.

## Spacing And Container Contract

### Container Stack
- `.page-section` wraps every major vertical section.
- `.section-shell` constrains width and carries section padding.
- `.section-header` contains section title, optional description, and optional action.
- `.section-body` contains the functional surface.

### Layout Rules
- New implementation must use the canonical wrapper stack above.
- Sections use consistent vertical rhythm.
- First section may omit the top divider; subsequent sections use the standard divider.
- Hero is the only section allowed stronger visual variation than the default section rhythm.
- Cards do not replace sections. Cards only appear inside `.section-body`.

## CTA Hierarchy Contract

### Tier 1: Primary CTA
- One primary CTA per page section cluster or card.
- Uses red interactive treatment.
- Represents the main forward action.

### Tier 2: Secondary CTA
- Supports the primary decision but does not compete visually.
- Uses border or text-link treatment.
- Only render when the supporting data exists.

### Tier 3: Tertiary Navigation
- Quiet inline links such as breadcrumbs, related links, and nearby-town links.
- Must remain visually subordinate to primary and secondary actions.

## Card Variant Contract

### Listing Card
- Used for business comparison surfaces.
- Requires `business_id`, `business_name`, `primary_category`, and at least one location or attribute signal.
- Primary action: view profile.

### Featured Card
- Uses the same structure as a listing card with featured-surface styling only.
- Must not introduce a different CTA hierarchy.

### Navigation Card
- Used for nearby towns, related categories, guides, or directory links.
- Requires one clear destination and one concise explanation.

### Detail Card
- Used for structured non-comparison information such as contact or support details.
- Must not masquerade as a primary action card.

## Edge Cases

- Missing `contact.phone`: hide call CTA.
- Missing `contact.website`: hide website CTA.
- Missing `description`: omit supporting paragraph.
- Missing `hours`: omit hours block.
- Missing breadcrumb parent route: render the crumb as plain text.
- Missing target id for a card: do not render the card as clickable.

## Friction Points

- Multiple equal CTA treatments create decision friction and are disallowed.
- Overuse of featured styling reduces trust and is disallowed.
- Long descriptive text before the first decision surface delays task completion and is disallowed.

## Open Risks

- Geo display labels are defined in linked geo entities, not in the `page` entity itself. CTO must preserve this relationship rather than duplicating geo text fields.
- Success-state needs are minimal in current MVP; implementation should not invent notification patterns without a real completion event.

## Compliance Note

- Authority mode: packet
- Authority source: `MAR-1192` comment `81221175-9dde-4a48-986b-b06f8ac570b6`
- Role: `UXDesigner`
- Artifact type: design-system consistency contract
- Domains covered: tokens, typography, spacing, CTA hierarchy, card variants, interaction states
- Conflicts: none
- Escalation: not required
