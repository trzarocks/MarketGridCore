# Astro Deployment Validation

## Purpose

Define the validation gates used by the Astro thin-slice deploy workflow.

## Validation Gates

### Hard Failures

These conditions must stop the run:

1. Missing required snapshot field for geo hub, category, listing, breadcrumbs, schema metadata, or required listing action/contact data.
2. Missing route template.
3. Duplicate slugs that violate geo/category/listing uniqueness rules.
4. Duplicate canonical URLs across active records.
5. Broken internal links in breadcrumbs, CTA/action panel links, or related links.
6. Invalid breadcrumbs (order, structure, or terminal node not matching page canonical).
7. Missing title or meta description required for emitted page records.
8. Invalid FAQ structure when FAQ is present (missing question/answer fields or malformed array object shape).
9. Missing listing contact/action data required for listing pages.
10. Invalid schema payloads for geo/category/listing pages.
11. Source records not in approved/published state for deployment promotion.
12. Build failure.
13. Generated route count mismatch against approved input route count.
14. Missing required output artifact.
15. Missing sitemap output.

### Non-Fatal Warnings

These conditions may be reported but must not block deployment:

1. Informational build output.
2. Extra snapshot fields that do not affect route emission or metadata validity.
3. Optional metadata fields present but unused by current render templates.
4. Optional FAQ omitted on pages where FAQ is not contract-required.
5. Optional related-links block omitted on page types where not required.
6. Non-blocking schema warnings that do not invalidate required schema fields.

Warnings are only acceptable when the required route and output contract remains intact.

## Validation Sequence

1. Validate snapshot data
2. Validate route presence
3. Validate canonical/slugs uniqueness
4. Validate publish/approval states
5. Validate internal links and breadcrumbs
6. Validate required metadata and FAQ structure
7. Validate listing contact/action coverage
8. Validate schema payloads
9. Build the site
10. Inspect output paths
11. Generate sitemap
12. Check expected artifact presence
13. Compare emitted route count to approved input route count

## Required Verification Commands

```bash
cd apps/astro-ssg-thin-slice
npm run validate:data
npm run validate:routes
npm run build
npm run build:inspect
npm run generate:sitemap
```

## References

- `docs/deployment/astro-ssg-deployment-contract.md`
- `docs/deployment/astro-thin-slice-workflow.md`
- `docs/deployment/astro-slice-completion-template.md`
