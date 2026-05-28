import { thinSlice } from '../data/thin-slice';

type Slice = (typeof thinSlice.slices)[number];
type Listing = Slice['listings'][number];

export interface NavTarget {
  label: string;
  href: string;
  description?: string;
}

function isValidHref(href: string): boolean {
  return href.startsWith('/') && href.length > 1;
}

export function suppressInvalidTargets(targets: NavTarget[], currentHref: string): NavTarget[] {
  const seen = new Set<string>();
  const normalizedCurrent = currentHref.endsWith('/') ? currentHref : `${currentHref}/`;

  return targets.filter((target) => {
    if (!target?.label || !target?.href) return false;
    if (!isValidHref(target.href)) return false;

    const normalizedHref = target.href.endsWith('/') ? target.href : `${target.href}/`;
    if (normalizedHref === normalizedCurrent) return false;
    if (seen.has(normalizedHref)) return false;

    seen.add(normalizedHref);
    return true;
  });
}

export function geoHubHref(slice: Slice): string {
  return `/${thinSlice.state.slug}/${slice.county.slug}/${slice.geo.slug}/`;
}

export function categoryHref(slice: Slice): string {
  return `${geoHubHref(slice)}business-directory/${slice.category.slug}/`;
}

export function listingHref(slice: Slice, listing: Listing): string {
  return `${categoryHref(slice)}${listing.slug}/`;
}

export function relatedCategoryTargets(slice: Slice): NavTarget[] {
  return thinSlice.slices
    .filter((candidate) => candidate.geo.slug === slice.geo.slug && candidate.category.slug !== slice.category.slug)
    .map((candidate) => ({
      label: candidate.category.name,
      href: categoryHref(candidate),
      description: `Explore ${candidate.category.name.toLowerCase()} in ${candidate.geo.name}`
    }));
}

export function nearbyGeoTargets(slice: Slice): NavTarget[] {
  return thinSlice.slices
    .filter((candidate) => candidate.geo.slug !== slice.geo.slug)
    .map((candidate) => ({
      label: candidate.geo.name,
      href: geoHubHref(candidate),
      description: candidate.county.name
    }));
}

export function nearbySameCategoryTargets(slice: Slice): NavTarget[] {
  return thinSlice.slices
    .filter((candidate) => candidate.category.slug === slice.category.slug && candidate.geo.slug !== slice.geo.slug)
    .map((candidate) => ({
      label: `${candidate.category.name} in ${candidate.geo.name}`,
      href: categoryHref(candidate),
      description: candidate.county.name
    }));
}

export function relatedListingTargets(slice: Slice, listing: Listing): NavTarget[] {
  return slice.listings
    .filter((candidate) => candidate.slug !== listing.slug)
    .map((candidate) => ({
      label: candidate.name,
      href: listingHref(slice, candidate),
      description: candidate.address
    }));
}
