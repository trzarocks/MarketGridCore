# Restaurant Listing Enrichment Contract

## Purpose

This contract defines the minimum restaurant-specific enrichment layer that sits between raw listing data and the approved MarketGrid listing-page template.

Its job is to convert raw business facts into decision-useful restaurant meaning before runtime copy is rendered.

It does not:

- create new page types
- change taxonomy
- change renderer layout
- change geo truth
- authorize unsupported restaurant claims

## Authority Note

Applied authority docs by required domain:

- hierarchy: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/site-architecture.md`
- page type behavior: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/pages/listing-page-system.md`
- taxonomy: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/category-governance-system.md`
- query/common-search behavior: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/common-searches-system.md`
- copy handoff governance: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/cmo-cto-content-handoff-governance.md`
- research truth and confidence: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/research-core.md`, `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/system/research-enrichment.md`
- fallback and user-facing locality tone: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/runtime/fallback-behavior.md`, `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/docs/runtime/human-place-writing.md`
- template and runtime surfaces: `docs/templates/business-listing-template.md`, `docs/runtime/rendering/listing-renderer-governance.md`, `docs/design-system/DESIGN.md`

Route pattern assumed:

- direct listing routes only: `/{town}/{category}/{business}/`

Primary CTA preserved:

- existing listing primary action only; this contract does not alter CTA hierarchy

## Demand Validation Gate

### Demand Decision 1

- Demand evaluated: `Restaurants` as the canonical category for restaurant listing enrichment
- Evidence type: `direct`
- Confidence: `high`
- Result: `PASS`
- Reasoning: approved Salisbury and Towson restaurant datasets, listing pages, and category governance already normalize cuisine variants under the single `Restaurants` category.

### Demand Decision 2

- Demand evaluated: `restaurant-specific enrichment between raw listing facts and the approved listing template`
- Evidence type: `direct`
- Confidence: `high`
- Result: `PASS`
- Reasoning: Salisbury success cases show richer restaurant-specific runtime meaning, while the Towson Banditos prototype shows that raw NAP data alone produces generic internal-sounding copy.

### Demand Decision 3

- Demand evaluated: `meal role`, `daypart`, `dining mode`, `occasion fit`, and `locality basis` as minimum restaurant decision fields
- Evidence type: `direct`
- Confidence: `high`
- Result: `PASS`
- Reasoning: these concepts are repeatedly supported by approved source evidence and current runtime outputs such as `breakfast`, `drinks first`, `group dining`, `date night`, `downtown`, and citywide fallback framing.

### Demand Decision 4

- Demand evaluated: `named cuisine subcategories`, `popularity`, `parking`, `price`, `atmosphere`, `walkability`, `reservation`, and `speed` as required enrichment fields
- Evidence type: `system`
- Confidence: `high`
- Result: `FAIL`
- Reasoning: those claims are either already normalized away at the category layer or remain unsupported or inconsistent in approved restaurant source packs.

### Demand Decision 5

- Demand evaluated: `new page types`, `new geo layers`, or `new taxonomy branches` as part of restaurant enrichment
- Evidence type: `system`
- Confidence: `high`
- Result: `FAIL`
- Reasoning: enrichment is a content-basis layer only and must map into the existing listing-page contract and approved locality systems.

## Why Raw Listing Data Is Not Enough

Raw fields such as:

- business name
- phone
- address
- website
- category

can prove identity and contactability, but they do not tell a user:

- what kind of meal stop this is
- when it fits
- whether it leans quick, social, group-friendly, or sit-down
- how much locality confidence exists
- what the copy must avoid claiming

Restaurant enrichment exists to fill that decision layer without inventing facts.

## Minimum MVP Enrichment Payload

The minimum payload below is the smallest contract that supports the approved listing template.

```json
{
  "contract_version": "v1.0",
  "artifact_revision": 1,
  "meal_role": "",
  "daypart": "",
  "dining_mode": "",
  "occasion_fit": [],
  "locality_basis": {
    "label": "",
    "kind": "",
    "source_confidence": ""
  },
  "use_case_frame": "",
  "source_confidence": "",
  "evidence_notes": "",
  "rendering_risk": [],
  "fallback_copy_basis": ""
}
```

### Field Definitions

#### `contract_version`

Schema contract version for storage and downstream consumers.

Rules:

- required on every enrichment payload
- bump only when field-level schema rules change

#### `artifact_revision`

In-place revision number for the stored enrichment payload.

Rules:

- required on every enrichment payload
- increment on every persisted change to the payload
- reset only when a new payload id is created

Absent metadata rule:
- if either `contract_version` or `artifact_revision` is absent, the payload must be treated as invalid for persistence and renderer input
- consumers must not backfill or infer missing version metadata from surrounding records

#### `meal_role`

Decision job the place plays in meal planning.

Allowed examples:

- `breakfast stop`
- `coffee and pastry stop`
- `quick lunch`
- `casual dinner`
- `sit-down dinner`
- `drinks-forward dinner`
- `seafood/raw-bar stop`
- `group meal`

Rules:

- one primary value
- do not turn cuisine into the field unless the cuisine is the meal job
- must be supportable by source evidence or repeated approved runtime evidence

#### `daypart`

Primary time-of-day fit.

Allowed examples:

- `morning`
- `lunch`
- `dinner`
- `late day`
- `flexible`

Rules:

- one value only
- use `flexible` when the place clearly spans multiple common meal windows and no single daypart leads

#### `dining_mode`

How the stop behaves.

Allowed examples:

- `quick stop`
- `casual meal`
- `full sit-down`
- `drinks first`
- `family table`
- `private event`
- `group dinner`

Rules:

- one primary value
- should describe visit behavior, not abstract brand identity

#### `occasion_fit`

Short list of supported scenarios.

Allowed examples:

- `date night`
- `family dinner`
- `campus visit`
- `errands day`
- `downtown evening`
- `driving-day stop`
- `group plan`

Rules:

- `1-3` values max
- keep behavioral, not promotional
- do not encode unsupported proximity

#### `locality_basis`

Bounded statement of the location context the listing copy may use.

Required subfields:

- `label`: user-facing locality basis such as `downtown`, `citywide`, `corridor-supported`, `campus-day overlay`, `regional-stop-safe fallback`
- `kind`: `direct`, `bounded_overlay`, `fallback`
- `source_confidence`: `direct`, `inferred`, `weak`, `fallback`

Rules:

- this is the contract between place intelligence and restaurant copy
- structural locality may be richer internally than the user-facing `label`
- do not surface hidden or rejected subgeo labels

#### `use_case_frame`

One short sentence describing how the place fits a real plan.

Examples:

- `Breakfast stop before or between Salisbury stops`
- `Downtown dinner that leans toward drinks and a longer table`
- `Flexible citywide dinner option for a group`

Rules:

- one sentence
- user-facing and plainspoken
- should summarize the decision help that `when_to_use` expands

#### `source_confidence`

Overall copy confidence for the enrichment record.

Allowed values:

- `direct`
- `inferred`
- `weak`
- `fallback`

Rules:

- `direct` means clearly anchored in approved source evidence or validated locality authority
- `inferred` means supported by multiple facts but not stated verbatim
- `weak` means thin evidence and tighter wording required
- `fallback` means copy must stay broad and factual

#### `evidence_notes`

Short internal note explaining what supports the enrichment.

Examples:

- `Chamber record names breakfast and bagels; Salisbury corridor authority supports moving-morning framing.`
- `Directory and approved runtime support downtown evening use, but not parking or event tie-in.`

Rules:

- concise
- must name evidence type, not prose aspirations

#### `rendering_risk`

List of claims the renderer or copy layer must avoid.

Allowed examples:

- `avoid proximity claim`
- `avoid district label`
- `avoid popularity claim`
- `avoid parking claim`
- `avoid speed claim`
- `avoid nightlife claim`
- `avoid price claim`

Rules:

- `1-4` items max
- required whenever locality or behavioral confidence is not fully direct

#### `fallback_copy_basis`

Short instruction for safe broad copy when evidence is thin.

Examples:

- `Keep this citywide and meal-specific; do not imply campus proximity.`
- `Use a practical contact-and-context check, not a district claim.`

Rules:

- one sentence
- must state what safe copy can still do

## Enrichment To Template Mapping

The template must not invent restaurant meaning. The enrichment layer supplies it.

| Template surface | Required enrichment basis | Mapping rule |
|---|---|---|
| `hero.description` | `meal_role`, `dining_mode`, `use_case_frame`, `locality_basis` | One short decision sentence. Avoid internal language and unsupported locality upgrades. |
| `what_they_do.summary` | same as `hero.description` or a materially different expansion | Suppress when it repeats `hero.description` too closely. |
| `services_capabilities.items` -> `Good For` | `meal_role`, `dining_mode`, strongest occasion or format cues | Keep to short tags such as `breakfast`, `quick bite`, `drinks first`, `group dining`. |
| `when_to_use.items` | `occasion_fit`, `use_case_frame`, `daypart`, `rendering_risk` | Three distinct user scenarios max. These should help a user decide, not restate raw category. |
| `context_local_fit.items` | `locality_basis`, `source_confidence`, `rendering_risk`, `fallback_copy_basis` | First line states supported fit. Second line states restraint boundary when needed. |
| hero chips | `location` plus `locality_basis.label` when supported | Chips may show `Towson, MD` plus restrained context like `Downtown plan` or `Citywide option`. |
| `Good For` | `services_capabilities.items` only | Do not duplicate hero chips into `Good For`. |
| `When This Fits` | `when_to_use.items` | Must feel like meal-planning guidance, not workflow instructions. |
| `Local Context` | `context_local_fit.items` | Secondary context only; do not let this become a district-invention surface. |

## Copy Realization Rules

Restaurant listing copy must sound like meal-planning help, not internal workflow.

### Required Direction

- plainspoken
- decision-first
- meal-specific
- locally restrained
- source-aware
- not promotional
- not overclaimed

### Prohibited User-Facing Phrases

Do not render:

- `direct fit confirmation`
- `matches their listed scope`
- `project matches`
- `listing profile`
- `source dataset`
- `business record`
- `runtime payload`
- `enrichment basis`
- `category contract`
- `decision surface`
- `local-fit`

### Realization Rules

1. Lead with the meal or visit job, not the system process.
2. Use one concrete behavioral contrast where helpful.
3. Keep hero and `What They Do` under the listing-page brevity limits.
4. Vary sentence structure across listings.
5. Treat overlays as scenario framing, not place identity.
6. Never convert internal confidence language into user-facing text.

## Safe Fallback Behavior

When evidence is thin, specificity must drop before accuracy does.

### Safe fallback should still do

- help a user confirm contact and basic fit
- keep the meal role broad but useful
- use citywide or neutral locality framing
- avoid internal or empty wording

### Safe fallback must not invent

- cuisine
- popularity
- atmosphere
- price
- parking
- walkability
- proximity
- district identity
- nightlife
- family-friendliness
- event support

unless the approved source set supports the claim.

### Fallback pattern

- `hero.description`: broad meal-use sentence
- `when_to_use.items`: human decision checks, not system instructions
- `context_local_fit.items`: neutral citywide or bounded locality language

### Bad fallback

`Use this profile when your restaurant project matches listed scope.`

### Better fallback

`Use this page when you need a simple way to check whether this restaurant fits the meal you are planning.`

### Better fallback with supportable city context

`Use this page when you are comparing restaurant options and need a quick contact-and-context check before deciding.`

## Locality And Place Intelligence Interaction

Restaurant enrichment may consume place context, but it does not redefine it.

### Rules

1. Use approved geo or place-intelligence outputs where available.
2. Keep locality claims bounded to surfaced authority.
3. Distinguish internal structural locality from public-facing labels.
4. Campus context stays behavioral unless direct proximity is sourced.
5. Corridors may support planned-stop framing only when approved.
6. Citywide fallback is acceptable when locality is weak.
7. Do not promote weak locality hints into named districts.

### Practical contract

- `direct` locality can support stronger `Local Context` phrasing.
- `bounded_overlay` locality can shape `When This Fits` but should not become chip or district identity unless approved.
- `fallback` locality must stay broad and avoid overlay-heavy prose.

## Worked Examples

### 1. Brew River Restaurant & Bar

- Raw signal:
  - Chamber evidence supports American restaurant and bar, three bars, downtown location, marina adjacency, banquet facilities.
- Enrichment interpretation:
  - `meal_role`: `drinks-forward dinner`
  - `daypart`: `dinner`
  - `dining_mode`: `drinks first`
  - `occasion_fit`: `downtown evening`, `group plan`
  - `locality_basis`: `downtown` / `direct`
  - `rendering_risk`: `avoid event tie-in`, `avoid parking claim`
- Safe runtime direction:
  - downtown dinner that leans toward drinks and a longer sit-down

### 2. Cactus Taverna Restaurant

- Raw signal:
  - Chamber evidence supports Mediterranean dining, family-friendly dining, full bar, catering, private banquet room.
- Enrichment interpretation:
  - `meal_role`: `group meal`
  - `daypart`: `dinner`
  - `dining_mode`: `family table`
  - `occasion_fit`: `family dinner`, `group plan`
  - `locality_basis`: `citywide` / `fallback`
  - `rendering_risk`: `avoid weaker downtown comparison`, `avoid named district`
- Safe runtime direction:
  - flexible Salisbury dinner option that can handle a group without tying the choice to one part of town

### 3. Bagel Bakery Cafe

- Raw signal:
  - Chamber evidence supports bagels, breakfast, meals; Salisbury corridor authority supports moving-morning framing.
- Enrichment interpretation:
  - `meal_role`: `breakfast stop`
  - `daypart`: `morning`
  - `dining_mode`: `quick stop`
  - `occasion_fit`: `campus visit`, `errands day`
  - `locality_basis`: `corridor-supported` with campus-day overlay
  - `rendering_risk`: `avoid campus proximity claim`, `avoid named district claim`
- Safe runtime direction:
  - breakfast stop that fits before or between campus plans and other Salisbury stops

### 4. Fuji Ramen House

- Raw signal:
  - Chamber evidence supports ramen, katsu don, gyoza; existing Salisbury runtime uses corridor support with behavioral campus-day context.
- Enrichment interpretation:
  - `meal_role`: `casual dinner`
  - `daypart`: `dinner`
  - `dining_mode`: `casual meal`
  - `occasion_fit`: `campus visit`, `driving-day stop`
  - `locality_basis`: `corridor-supported` with bounded overlay
  - `rendering_risk`: `avoid walkable-from-campus claim`
- Safe runtime direction:
  - casual meal that fits a campus visit or multi-stop day without taking over the schedule

### 5. East Moon Steak House

- Raw signal:
  - Chamber evidence supports hibachi, sushi, Japanese dinners, business-meeting or company-party space.
- Enrichment interpretation:
  - `meal_role`: `sit-down dinner`
  - `daypart`: `dinner`
  - `dining_mode`: `group dinner`
  - `occasion_fit`: `group plan`, `family dinner`
  - `locality_basis`: `corridor-supported`
  - `rendering_risk`: `avoid district identity`, `avoid speed/traffic claim`
- Safe runtime direction:
  - fuller sit-down dinner stop for a driving-day plan or group table

### 6. Banditos Bar & Kitchen Failure Case

- Raw signal:
  - Towson Chamber record proves name, phone, address, and restaurant category.
  - Additional approved Towson place or category authority is required before using downtown or social-use framing in user-facing listing copy.
- Failed realization:
  - `Towson restaurant listing profile for direct fit confirmation and immediate contact.`
  - `Use Banditos Bar & Kitchen when your Towson restaurants project matches their listed scope and you want to confirm fit directly.`
- Failure reason:
  - raw facts rendered without restaurant-specific enrichment
  - internal workflow language leaked to users
  - no meal role, daypart, dining mode, or authority-bounded locality framing was supplied
- Correct direction:
  - do not use downtown or social-use framing unless approved Towson place or category authority is loaded alongside the Chamber facts

## Validation Checklist

Every restaurant listing enrichment record must answer:

1. Are `contract_version` and `artifact_revision` both present and non-empty?
2. If the payload changed, was `artifact_revision` incremented?
3. Does the listing have one supportable `meal_role`?
4. Does it have one primary `daypart` or a justified `flexible` fallback?
5. Does `dining_mode` describe visit behavior rather than abstract branding?
6. Are `occasion_fit` values distinct and supportable?
7. Is `locality_basis` approved, bounded, and confidence-labeled?
8. Does the copy avoid internal workflow language?
9. Does the page avoid invented proximity or district claims?
10. Are hero chips distinct from `Good For` tags?
11. Is `What They Do` materially different from `hero.description`, or should it be suppressed?
12. Is fallback copy still useful to a human when evidence is thin?
13. Does the output support the approved listing template without adding sections or route changes?

## Future Consumption Guidance

Future restaurant listing-generation tasks should load in this order:

1. `docs/enrichment/restaurant-listing-enrichment-contract.md`
2. `docs/templates/business-listing-template.md`
3. `docs/runtime/rendering/listing-renderer-governance.md`
4. `docs/design-system/DESIGN.md`
5. applicable geo or place-intelligence authority for the town

If execution work is needed later, include a `## Copy Handoff` block that cites this contract as the canonical enrichment authority before CTO implementation starts.
