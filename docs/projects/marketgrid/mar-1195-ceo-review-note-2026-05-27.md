# MAR-1195 CEO Review Note

Date: 2026-05-27
Reviewer: CEO
Issue: MAR-1195
Context: Review of the uncommitted Astro design-system realization diff and triage of new design-system docs after board comment `c5943e18-74bd-4700-8634-65518b994258`.

## Review Outcome

Disposition recommendation: `blocked`

Unblock owner: CTO

Unblock action:
- remove duplicate page-level primary CTA treatment so each affected page exposes one primary CTA path per the new assembly contract
- trim or re-scope the new design-system docs so ownership boundaries are clearer and repeated contract text does not drift

## Findings

### 1. Duplicate primary CTA treatment violates the new page-assembly contract

Severity: medium

Authority:
- `docs/design-system/page-assembly-rules.md:98` says the page-level primary CTA appears in the hero or the first decision surface, not both as equal peers

Evidence:
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/index.astro:26` puts a primary CTA in the hero
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/index.astro:36` repeats the same destination as another primary CTA in the first decision surface
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/[listing]/index.astro:41` puts a primary CTA in the hero
- `apps/astro-ssg-thin-slice/src/pages/[state]/[geo]/business-directory/[category]/[listing]/index.astro:53` repeats the same action as another primary CTA in the detail surface

Why this matters:
- the new reusable layer is supposed to formalize CTA hierarchy, not duplicate it
- this creates a direct mismatch between the approved assembly contract and the implementation being reviewed
- if this lands as-is, downstream template work inherits the wrong CTA pattern

Required correction:
- choose one primary CTA surface on the geo page and one on the listing page
- keep any secondary navigation or support action subordinate in the other surface

## Doc Triage

### Keep

- `docs/design-system/design-system-consistency.md`
  - keep as the canonical token, typography, CTA hierarchy, and cross-page behavior contract
- `docs/design-system/component-inventory.md`
  - keep as the reusable primitive contract
- `docs/design-system/page-assembly-rules.md`
  - keep as the section-order and wrapper-assembly contract
- `docs/design-system/DESIGN.md`
  - keep as a narrowed legacy-preservation note only

### Cleanup Needed

The new doc set is directionally correct, but it currently repeats contract content across files:

- `design-system-consistency.md` repeats entry points, user flow, states, and data requirement material that overlaps with `page-assembly-rules.md`
- `component-inventory.md` also repeats entry points, user flow, and some interaction/state framing rather than staying tightly scoped to component contracts

This is not a reason to reject the design-system split, but it is enough duplication to create future authority drift.

### Consolidation Recommendation

Do not collapse the three new canonical files back into one document. The split is useful. Instead:

- let `design-system-consistency.md` own tokens, typography, CTA hierarchy, and global interaction/state rules
- let `component-inventory.md` own component-specific inputs, outputs, rules, and states only
- let `page-assembly-rules.md` own page section order, wrapper stack, page-type realization rules, and placement constraints only
- remove repeated user-flow and repeated data-requirement sections where another canonical file already owns them
- keep `DESIGN.md` as a short pointer and historical-intent note

## Approval Status

Not approved for closeout yet.

Closeout condition:
- CTO resolves the CTA hierarchy mismatch in the affected pages
- CTO performs a light cleanup pass on the new design-system docs to reduce duplicated authority text without changing the intended contract split
