import countries from 'country-code-lookup';
import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';

const INPUT_CSV = 'data/publications/source-v071_publications_by_country.csv';
const OUTPUT_CSV = 'data/publications/publication-overlap-by-country.csv';

const publications = Papa.parse(readFileSync(INPUT_CSV).toString(), {
  header: true,
  dynamicTyping: true,
});

const results = publications.data
  .filter(({ country, count }) => country && Number.isFinite(count))
  .map(({ country, iso3, count }) => {
    const countryMeta = iso3 ? countries.byIso(iso3) : countries.byCountry(country);
    return {
      country,
      iso3,
      countryId: countryMeta?.isoNo ?? '',
      publications: count,
    };
  })
  .sort((a, b) => b.publications - a.publications);

writeFileSync(OUTPUT_CSV, Papa.unparse(results, { header: true }));
