import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const manifestPath = path.resolve(root, '../src/data/thin-slice.json');

const raw = await fs.readFile(manifestPath, 'utf8');
const data = JSON.parse(raw);

const required = [
  ['state.slug', data.state?.slug],
  ['slices', Array.isArray(data.slices) && data.slices.length > 0]
];

for (const [label, value] of required) {
  if (!value) {
    throw new Error(`Missing required snapshot field: ${label}`);
  }
}

const geoSlugs = new Set();

for (const slice of data.slices) {
  const categorySlug = slice.category?.slug;
  const geoSlug = slice.geo?.slug;
  const listings = Array.isArray(slice.listings) ? slice.listings : [];

  if (!geoSlug || !categorySlug) {
    throw new Error('Missing required snapshot field: slices[*].geo.slug or slices[*].category.slug');
  }
  if (geoSlugs.has(geoSlug)) {
    throw new Error(`Duplicate geo slug detected: ${geoSlug}`);
  }
  geoSlugs.add(geoSlug);

  if (listings.length === 0) {
    throw new Error(`Slice ${geoSlug}/${categorySlug} requires at least one listing.`);
  }

  const listingSlugs = new Set();
  for (const listing of listings) {
    if (!listing.slug || !listing.address || !listing.phone) {
      throw new Error(`Listing in ${geoSlug}/${categorySlug} is missing slug/address/phone.`);
    }
    if (listingSlugs.has(listing.slug)) {
      throw new Error(`Duplicate listing slug in ${geoSlug}/${categorySlug}: ${listing.slug}`);
    }
    listingSlugs.add(listing.slug);
  }
}

console.log(`Validated snapshot manifest at ${manifestPath}`);
