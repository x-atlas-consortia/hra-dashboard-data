import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';

const INPUT_CSV = 'data/publications/source-publication_overlap_by_year.csv';
const OUTPUT_CSV = 'data/publications/publication-overlap-by-year.csv';

const publications = Papa.parse(readFileSync(INPUT_CSV).toString(), {
  header: true,
  dynamicTyping: true,
});

const SERIES = [
  ['unique_only_in_hra_v071', 'Only in HRA v0.7.1'],
  ['unique_only_in_hralit_v050', 'Only in HRAlit v0.5.0'],
  ['unique_in_both_datasets', 'In both datasets'],
];

const grouped = new Map();

for (const row of publications.data) {
  if (!Number.isFinite(row.publication_year)) {
    continue;
  }

  const year = row.publication_year < 1950 ? '<1950' : String(row.publication_year);
  const yearOrder = row.publication_year < 1950 ? 1949 : row.publication_year;

  for (const [field, series] of SERIES) {
    const key = `${yearOrder}:${series}`;
    const publicationsCount = Number(row[field] ?? 0);
    if (!grouped.has(key)) {
      grouped.set(key, {
        year,
        year_order: yearOrder,
        series,
        publications: 0,
      });
    }
    grouped.get(key).publications += publicationsCount;
  }
}

const results = Array.from(grouped.values()).sort((a, b) => {
  if (a.year_order !== b.year_order) {
    return a.year_order - b.year_order;
  }
  return a.series.localeCompare(b.series);
});

writeFileSync(OUTPUT_CSV, Papa.unparse(results, { header: true }));
