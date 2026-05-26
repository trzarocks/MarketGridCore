# MarketGrid Design Authority — Listing Template Preservation

## Purpose
Preserve the approved listing-template visual authority and prevent regression to generic HTML shells.

## Current Static Visual Authority
- Authoritative static visual source: `docs/templates/business-directory-universal.html`
- This authority applies to listing-template prototype visual structure and styling direction.

## Authority Distinctions
- Design prototype authority: visual language, hierarchy, and section treatment from `business-directory-universal.html`.
- Contract prototype authority: field coverage and mapping validation artifacts.
- Runtime JSON authority: content payload only; not a visual spec.

## Preservation Rule
Unless explicitly assigned a redesign task, agents must preserve the existing MarketGrid visual direction when generating or updating listing template outputs.

## Required Listing Behaviors To Preserve
- Two-column hero with Quick Info/CTA on the right (desktop), stacked on mobile.
- Hero chips represent location/locality context, not `Good For` tags.
- `Good For` maps from `services_capabilities.items`.
- `Local Context` uses secondary treatment.
- No duplicate lower Action Panel when hero CTA is present.
- No debug/state/contract UI in user-facing output.
- Website row label shown as `Visit Website`.

## Non-Goals
This document does not authorize:
- template redesign,
- copy rewrites,
- routing changes,
- CMS/frontend implementation.
