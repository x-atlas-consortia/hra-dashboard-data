import { readFileSync, writeFileSync } from 'fs';
import geoip from 'geoip-lite';
import Papa from 'papaparse';

const INPUT_FIELD = 'ip';
const OUTPUT_FIELD = 'country';
const INPUT_CSV = process.argv[2];
const ENRICHED_CSV = process.argv[3];

const data = Papa.parse(readFileSync(INPUT_CSV, 'utf8'), {
  header: true,
  skipEmptyLines: true,
}).data;

for (const item of data) {
  const country = geoip.lookup(item[INPUT_FIELD])?.country;
  item[OUTPUT_FIELD] = country;
}

writeFileSync(
  ENRICHED_CSV,
  Papa.unparse(
    data.filter((item) => !!item.country),
    { header: true }
  )
);
