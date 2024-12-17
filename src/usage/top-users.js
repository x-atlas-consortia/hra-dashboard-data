import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';

const INPUT_CSV = 'data/usage/raw-referrer-requests.csv';
const OUTPUT_CSV = 'data/usage/user-requests.csv';

const referrers = Papa.parse(readFileSync(INPUT_CSV).toString(), { header: true, dynamicTyping: true });

const USERS = {
  'hubmapconsortium.org': 'HuBMAP',
  'sennetconsortium.org': 'SenNet',
  'kpmp.org': 'KPMP',
  'gudmap.org': 'GUDMAP',
  'atlas-d2k.org': 'GUDMAP',
  'gtexportal.org': 'GTEx',
  'www.ebi.ac.uk': 'EBI',
  'cellxgene.cziscience.com': 'CZ CELLxGENE',
  'single-cell.czi.technology': 'CZ CELLxGENE',
  'ontobee.org': 'OntoBee',
};

const userRequests = {};
for (let { host, date, requests } of referrers.data.filter((s) => !!s.host)) {
  host = host ? host + '' : host;
  const user = Object.entries(USERS).find(([url, _username]) => host.includes(url))?.[1];
  if (user) {
    userRequests[user] ??= {}
    userRequests[user][date] ??= 0;
    userRequests[user][date] += requests;
  }
}

const results = [];
for (const [user, requestsByDate] of Object.entries(userRequests)) {
  for (const [date, requests] of Object.entries(requestsByDate).sort((a, b) => b[0].localeCompare(a[0]))) {
    results.push({ user, date, requests });
  }
}

writeFileSync(OUTPUT_CSV, Papa.unparse(results, { header: true }));
