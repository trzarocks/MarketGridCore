import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const dist = path.resolve(root, '../dist');
const entries = [];

async function walk(dir) {
  for (const entry of await fs.readdir(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      await walk(full);
    } else if (entry.name === 'index.html') {
      entries.push(path.relative(dist, full));
    }
  }
}

await walk(dist);
entries.sort();
console.log(entries.join('\n'));
