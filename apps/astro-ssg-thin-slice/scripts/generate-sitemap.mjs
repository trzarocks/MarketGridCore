import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const dist = path.resolve(root, '../dist');
const dataPath = path.resolve(root, '../src/data/thin-slice.json');
const data = JSON.parse(await fs.readFile(dataPath, 'utf8'));

const urls = ['/', `/${data.state.slug}/`];
for (const slice of data.slices) {
  const geoRoot = `/${data.state.slug}/${slice.geo.slug}/`;
  const categoryRoot = `${geoRoot}business-directory/${slice.category.slug}/`;
  urls.push(geoRoot, categoryRoot);
  for (const listing of slice.listings) {
    urls.push(`${categoryRoot}${listing.slug}/`);
  }
}

const xml = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls.map((url) => `  <url><loc>${url}</loc></url>`).join('\n')}\n</urlset>\n`;

await fs.writeFile(path.join(dist, 'sitemap.xml'), xml, 'utf8');
console.log(`Wrote sitemap.xml with ${urls.length} URLs.`);
