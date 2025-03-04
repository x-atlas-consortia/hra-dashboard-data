import { readFileSync, writeFileSync } from 'fs';
import Papa from 'papaparse';

const OUTPUT = 'data/data/hra-growth.csv';
const ATLAS = 'data/data/hra-growth.atlas.csv';
const EXPERIMENTAL = 'data/data/hra-growth.experimental.csv';
const HRAlit = 'data/data/hra-growth.hra-lit.csv';
const SOPs = 'data/data/hra-growth.sop.csv';

function readCsv(csvFile) {
  const csvString = readFileSync(csvFile).toString();
  const result = Papa.parse(csvString, { header: true, dynamicTyping: true, skipEmptyLines: true });
  return result.data;
}

function decumulate(sortedData) {
  const results = [];
  let lastGroup;
  let lastCount;
  for (const row of sortedData) {
    if (lastGroup != row.group) {
      lastGroup = row.group;
      lastCount = 0;
    }
    results.push({
      group: row.group,
      date: row.date,
      count: row.count - lastCount,
      fooCount: row.count,
      order: row.order
    });
    lastCount = row.count;
  }
  return results;
}

function accumulate(group, order, dateAndCountEntries) {
  const countsByDate = dateAndCountEntries.reduce((acc, [date, count]) => {
    acc[date] = (acc[date] ?? 0) + count;
    return acc;
  }, {});
  return Object.entries(countsByDate)
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([date, count]) => ({
      group,
      date,
      count,
      order,
    }));
}

function parseExperimental() {
  const groups = readCsv(EXPERIMENTAL)
    .filter((row) => row.date)
    .reduce((acc, row) => {
      acc[row.group] = acc[row.group] ?? [];
      acc[row.group].push(row);
      return acc;
    }, {});
  return Object.entries(groups).reduce(
    (acc, [group, rows]) =>
      acc.concat(
        accumulate(
          group,
          rows[0].order,
          rows.map((row) => [row.date, row.count])
        )
      ),
    []
  );
}

function parseAtlas() {
  return decumulate(readCsv(ATLAS));
}

function parseHraLit() {
  const entries = readCsv(HRAlit)
    .filter((row) => row.pubyear && row.pubyear >= 2019)
    .map((row) => [`${row.pubyear || '0000'}-01-01`, 1]);
  return accumulate('publications', 3, entries);
}

function parseSOPs() {
  const entries = readCsv(SOPs).map((row) => [row.created.toISOString().slice(0, 10), 1]);
  return accumulate('SOPs', 10, entries);
}

const results = [...parseExperimental(), /*...parseHraLit(),*/ ...parseAtlas(), ...parseSOPs()];
const csvString = Papa.unparse(results, { header: true });
writeFileSync(OUTPUT, csvString);
