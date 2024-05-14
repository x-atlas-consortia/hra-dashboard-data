import aircodes from 'aircodes';
import countries from 'country-code-lookup';
import { readFileSync, writeFileSync } from 'fs';
import geoip from 'geoip-lite';
import Papa from 'papaparse';
import { athenaQuery } from '../utils/athena.js';

const INPUT_SQL = 'queries/athena/usage/global-portal-usage.sql';
const OUTPUT = 'data/usage/global-portal-usage.csv';

const query = readFileSync(INPUT_SQL).toString();
let minDate = Number.MAX_SAFE_INTEGER;
let maxDate = Number.MIN_SAFE_INTEGER;
const countryRequests = {};
for await (const item of athenaQuery.query(query)) {
  minDate = Math.min(minDate, new Date(item.start_date).getTime());
  maxDate = Math.max(maxDate, new Date(item.end_date).getTime());

  const ipLocation = geoip.lookup(item.ip);
  const airport = aircodes.getAirportByIata(item.airport);
  let country;
  if (ipLocation) {
    country = ipLocation.country;
    const fips = countries.byFips(ipLocation.country);
    const internet = countries.byInternet(ipLocation.country);
    if (fips) {
      country = fips.country;
    } else if (internet) {
      country = internet.country;
    }
  }
  if (!country && airport) {
    country = airport.country.replace('1 ', '');
  }
  if (!country) {
    country = 'Unknown';
    console.log('Found unknown result:', item);
  }
  countryRequests[country] = (countryRequests[country] ?? 0) + item.requests;
}

const results = Object.entries(countryRequests)
  .map(([country, results]) => {
    const countryMeta = countries.byCountry(country) ?? 'Unknown';
    return {
      country,
      countryId: countryMeta.isoNo,
      results,
    };
  })
  .sort((a, b) => b.results - a.results);

writeFileSync(OUTPUT, Papa.unparse(results, { header: true }));
