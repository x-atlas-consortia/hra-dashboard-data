import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';
import { athenaQuery } from '../utils/athena.js';

const IN_SQL = process.argv[2];
const OUTPUT = process.argv.length === 4 ? process.argv[3] : '';

const query = readFileSync(IN_SQL).toString();
const results = [];
for await (const item of athenaQuery.query(query)) {
  results.push(item);
}

if (OUTPUT.endsWith('.json')) {
  writeFileSync(OUTPUT, JSON.stringify(results, null, 2));
} else if (OUTPUT.endsWith('.csv')) {
  const csvString = Papa.unparse(results, { header: true });
  writeFileSync(OUTPUT, csvString);
}
