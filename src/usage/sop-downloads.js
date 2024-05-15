const API =
  'https://zenodo.org/api/communities/ef4a7af8-55bb-4304-9ea4-80c5186236c9/records?q=&sort=newest&page=1&size=50';

const results = await fetch(API).then((r) => r.json());
const count = results.hits.hits.map((n) => n.stats.downloads).reduce((a, b) => a + b, 0);

console.log(count);
