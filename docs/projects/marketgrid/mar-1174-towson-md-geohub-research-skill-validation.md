# MAR-1174 Towson, MD Geohub Research Skill Validation

Date: 2026-05-25
Owner: CMO
Status: Delivered

## Objective
Validate the rewritten geohub research workflow on one real geography slice and produce a source-grounded output that CTO and UX can use without additional demand invention.

## Validation Scope
- Geo under test: `Towson, MD`
- Target page type: `GEO_HUB`
- Route pattern assumed: `direct`
- Geo hub route: `/towson-md/`
- Breadcrumb pattern assumed: `Home -> Towson`
- Primary CTA for downstream build: `Browse Towson business categories`
- Note: no repo-local `MAR-1174` prompt artifact was present in this checkout, so this document validates the governed geohub research workflow itself against one real slice.

## Authority Docs Applied
- Hierarchy: `docs/system/site-architecture.md`
- Page behavior: `docs/pages/geo-hub-system.md`
- Taxonomy: `docs/system/category-governance-system.md`
- Common searches: `docs/system/common-searches-system.md`
- Geo signal contract: `docs/geo/geo-signal-profile.md`
- Geo research framing: `docs/geo/geo-research.md`
- Geo tags: `docs/geo/geo-tag-system.md`
- Research methodology: `docs/system/research-core.md`
- Demand gate: `docs/validators/demand-validation.md`

## Source Set
1. Maryland Secretary of State county reference: Towson is the present county seat of Baltimore County.
   - https://sos.maryland.gov/mdkids/Pages/counties/Baltimore-County.aspx
2. Towson University visit page: Towson University is in the heart of Towson; the campus is within walking distance of the college town, restaurants, bookstores, library branch, movies, and shopping.
   - https://www.towson.edu/visit/
3. Towson University housing page: 18 residence halls and apartments; 5,500+ students live on campus.
   - https://www.towson.edu/studentlife/housing/campus/index.html
4. Towson Chamber about page: 350+ businesses; Spring Festival, Farmers Market, Feet on the Street, and Taste of Towson with 30+ restaurants.
   - https://www.towsonchamber.com/about/
5. Towson Chamber 2023-2024 directory PDF: categorical `RESTAURANTS` listings plus Towson map references for restaurants, bars, and eateries.
   - https://www.towsonchamber.com/site/wp-content/uploads/2023/11/Directory-2023-for-website-Reduced.pdf
6. Giant Food Towson location page: direct grocery-store presence in Towson.
   - https://stores.giantfood.com/md/towson
7. Baltimore Magazine Towson dentist directory: repeated dentist listings in Towson.
   - https://www.baltimoremagazine.com/directory/dentists/locations/towson/
8. Towson plumber directory page: repeated plumber listings in Towson.
   - https://plumberdirectories.com/maryland/towson

## Geo Signal Profile
```yaml
geo:
  name: Towson
  type: town
  region: Baltimore County, Maryland
  target_use: geo-hub research validation and constrained local content support

signals:
  - name: county-seat civic center
    category: structural
    confidence: high
    source_grounding:
      - fact: Baltimore County's county seat was moved to its present location in Towson.
        source: https://sos.maryland.gov/mdkids/Pages/counties/Baltimore-County.aspx
    allowed_interpretations:
      - Copy may frame Towson as a county-seat place where civic destinations and administrative visits are part of local decision-making.
      - UX may prioritize civic-orientation language in hero and explore cues.
    disallowed_claims:
      - Do not claim every user trip is government-related.
      - Do not infer permit, licensing, or courthouse demand for any specific category.

  - name: walkable college-town anchor
    category: cultural
    confidence: high
    source_grounding:
      - fact: Towson University says its campus is located in the heart of Towson and within walking distance of the college town.
        source: https://www.towson.edu/visit/
      - fact: Towson University reports 18 residence halls and apartments with 5,500+ students living on campus.
        source: https://www.towson.edu/studentlife/housing/campus/index.html
    allowed_interpretations:
      - Copy may frame Towson as a college-linked place with student and visitor foot traffic.
      - UX may keep explore and common-search phrasing oriented to walkable, mixed-use activity.
    disallowed_claims:
      - Do not claim student demand volumes by category.
      - Do not imply nightlife leadership, affordability, or youth preference without separate sourcing.

  - name: event-driven restaurant corridor
    category: activity
    confidence: high
    source_grounding:
      - fact: The Towson Chamber says Taste of Towson features over 30 restaurants from the Towson area.
        source: https://www.towsonchamber.com/about/
      - fact: The Towson Chamber directory identifies restaurant clusters on Chesapeake and Allegheny, plus a categorical `RESTAURANTS` section.
        source: https://www.towsonchamber.com/site/wp-content/uploads/2023/11/Directory-2023-for-website-Reduced.pdf
    allowed_interpretations:
      - Copy may describe Towson as a place with a visible restaurant and event corridor, especially around downtown streets and Chamber-led events.
      - UX may emphasize food discovery as a strong primary-pathway candidate from the geo hub.
    disallowed_claims:
      - Do not call Towson a dining capital or make best-in-region claims.
      - Do not imply every subarea has the same restaurant density.

  - name: everyday-retail access node
    category: economic
    confidence: medium
    source_grounding:
      - fact: Towson University describes Towson as within walking distance of restaurants, bookstores, movies, and shopping.
        source: https://www.towson.edu/visit/
      - fact: Giant Food maintains a Towson grocery location at 8100 Loch Raven Blvd.
        source: https://stores.giantfood.com/md/towson
    allowed_interpretations:
      - Copy may frame Towson as a place where everyday errands and shopping are part of the core town experience.
      - UX may preserve a commerce/everyday demand path on the geo hub.
    disallowed_claims:
      - Do not claim complete retail coverage or superior pricing.
      - Do not infer mall performance, vacancy, or shopper volume from this signal alone.
```

## Approved Geo Tags
- County Seat
- College Town
- Walkable Core
- Restaurant Corridor
- Everyday Shopping

## Demand Validation Gate
All query and category decisions below were checked against `docs/validators/demand-validation.md`.

| Demand evaluated | Evidence type | Confidence | Result | Reasoning |
|---|---|---:|---|---|
| `restaurants` | direct | high | PASS | Towson Chamber documents 30+ restaurants in Taste of Towson and publishes restaurant categorical listings. |
| `plumbers` | direct + system | medium | PASS | Plumbers are a system-critical category and local directory evidence shows repeated Towson plumber listings. |
| `dentists` | direct + system | high | PASS | Baltimore Magazine's Towson dentist directory shows repeated Towson dental listings, and dentists are a stable user-facing category. |
| `grocery stores` | direct | medium | PASS | Giant Food has a direct Towson store page, supporting local grocery intent without inventing subcategories. |
| `late-night food in Towson` | proxy | medium | PASS with caution | Chamber restaurant corridor evidence supports food-intent phrasing, but downstream copy must avoid unsupported late-night coverage claims unless tied to approved entities. |
| `student apartments in Towson` | proxy | low | FAIL | University housing evidence supports campus residence, not a canonical MarketGrid business category for this geo-hub flow. |
| `best nightlife in Towson` | speculative | low | FAIL | Source set supports events and restaurants, not comparative nightlife rankings. |
| `luxury shopping in Towson` | speculative | low | FAIL | Shopping presence is supported; luxury positioning is not. |

## Approved Query-to-Page Map
These are the approved high-intent geo-hub common-search candidates for Towson. They follow `docs/system/common-searches-system.md` and map to existing allowed page destinations.

| Pillar | Approved query | Destination type | Route target | Demand status | Notes for CTO and UX |
|---|---|---|---|---|---|
| Home | `Emergency plumber in Towson` | category page | `/towson-md/plumbers/` | PASS | Keep wording urgent and functional; do not add unsupported speed guarantees in copy. |
| Food | `Restaurants in Towson` | category page | `/towson-md/restaurants/` | PASS | Strongest direct-demand path for this slice; acceptable as primary CTA destination candidate. |
| Personal | `Dentist near Towson` | category page | `/towson-md/dentists/` | PASS | `near` phrasing is acceptable human-language search style; avoid narrowing to specialties unless separately validated. |
| Commerce / Everyday | `Grocery stores in Towson` | category page | `/towson-md/grocery-stores/` | PASS | Use as errands/everyday-intent path, not as a shopping-superlative claim. |

## Rejected or Withheld Query Ideas
- `Best nightlife in Towson`
  - FAIL: unsupported comparative framing.
- `Student housing in Towson`
  - FAIL: outside approved category scope for this geo-hub demand pass.
- `Luxury shopping in Towson`
  - FAIL: retail presence does not support luxury positioning.
- `Open late food in Towson`
  - WITHHOLD: acceptable only if tied to approved entity-level hours evidence later.

## Immediate Handoff For CTO
- Use `/towson-md/` as the direct geo-hub route.
- Use `Browse Towson business categories` as the single primary CTA label or an equivalent meaning-preserving variant.
- Treat `Restaurants in Towson` as the strongest direct category pathway from the hero or category-groups surface.
- Keep geo-hub identity anchored to `county-seat civic center`, `walkable college-town anchor`, `event-driven restaurant corridor`, and `everyday-retail access node`.
- Do not introduce nightlife, luxury-shopping, or student-housing claims in hero, tags, common searches, or FAQs without new source approval.

## Immediate Handoff For UX
- Bias the visual and content emphasis toward a walkable mixed-use town with civic and campus anchors, not a generic suburb.
- Food and exploration surfaces should feel stronger than speculative nightlife positioning.
- Commerce / everyday should read as practical errands and shopping access, not prestige retail.
- Any local flavor in hero, feels-like, or explore modules must stay above the neighborhood level unless separate locality authority is added.

## Outcome
The Towson slice passes validation as a real, source-grounded geohub research sample. The workflow produced:
- 4 approved geo signals
- 5 approved geo tags
- 4 approved common-search queries with route targets
- 4 explicit rejected/withheld ideas to prevent unsupported downstream expansion
