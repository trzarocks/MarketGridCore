import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const appRoot = path.resolve(root, '..');
const routes = [
  'src/pages/index.astro',
  'src/pages/[state]/index.astro',
  'src/pages/[state]/[county]/[geo]/index.astro',
  'src/pages/[state]/[county]/[geo]/business-directory/[category]/index.astro',
  'src/pages/[state]/[county]/[geo]/business-directory/[category]/[listing]/index.astro'
];

for (const route of routes) {
  await fs.access(path.join(appRoot, route));
}

console.log(`Validated ${routes.length} route templates.`);
