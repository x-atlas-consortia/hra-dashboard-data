import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';

const INPUT_CSV = 'data/usage/raw-referrers.csv';
const OUTPUT_CSV = 'data/usage/top-referrers.csv';

const referrers = Papa.parse(readFileSync(INPUT_CSV).toString(), { header: true, dynamicTyping: true });
const RENAMES = {
  'www.gtexportal.org': 'gtexportal.org',
  'test.gtexportal.org': 'gtexportal.org',
  'data.dev.sennetconsortium.org': 'data.sennetconsortium.org',
  'portal-prod.stage.hubmapconsortium.org': 'portal.hubmapconsortium.org',
  'portal.dev.hubmapconsortium.org': 'portal.hubmapconsortium.org',
  'portal.test.hubmapconsortium.org': 'portal.hubmapconsortium.org',
};
const SKIP = new Set([
  '127.0.0.1',
  'localhost',
  'hubmapconsortium.github.io',
  'ccf-ontology.hubmapconsortium.org',
  'hubmap-ccf-ui.netlify.app',
  'kparekh21.github.io', // hra-pop-validation
  'humanatlas-io.netlify.app',
]);

const requestsByHost = {};
for (let { host, requests } of referrers.data) {
  host = host ? host + '' : host;
  if (host && !SKIP.has(host) && !host.endsWith('humanatlas.io') && !host.endsWith('cloudfront.net') && !host.includes('hubmap-ccf-ui.netlify.app') && !host.includes('hra-ui.netlify.app')) {
    host = RENAMES[host] ?? host;
    requestsByHost[host] = (requestsByHost[host] ?? 0) + requests;
  }
}

const results = Object.entries(requestsByHost)
  .map(([host, requests]) => ({ host, requests }))
  .sort((a, b) => b.requests - a.requests)
  .slice(0, 10);

writeFileSync(OUTPUT_CSV, Papa.unparse(results, { header: true }));
