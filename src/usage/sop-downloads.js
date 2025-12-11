const API1 =
  'https://zenodo.org/api/communities/ef4a7af8-55bb-4304-9ea4-80c5186236c9/records?q=&sort=newest&page=1&size=25';
const API2 =
  'https://zenodo.org/api/communities/ef4a7af8-55bb-4304-9ea4-80c5186236c9/records?q=&sort=newest&page=1&size=25';


let results = await fetch(API1).then((r) => r.json());
let count = results.hits.hits.map((n) => n.stats.downloads).reduce((a, b) => a + b, 0);

results = await fetch(API2).then((r) => r.json());
count += results.hits.hits.map((n) => n.stats.downloads).reduce((a, b) => a + b, 0);

console.log(count);
