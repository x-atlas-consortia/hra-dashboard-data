#!/bin/bash
shopt -s extglob
set -ev

ENDPOINT=https://lod.humanatlas.io/sparql
# ENDPOINT=http://localhost:8080/blazegraph/namespace/kb/sparql

HRALIT_PUBS=https://api.figshare.com/v2/file/download/44343890
SOPs1="https://zenodo.org/api/communities/ef4a7af8-55bb-4304-9ea4-80c5186236c9/records?q=&sort=newest&page=1&size=25"
SOPs2="https://zenodo.org/api/communities/ef4a7af8-55bb-4304-9ea4-80c5186236c9/records?q=&sort=newest&page=2&size=25"

src/cli/sparql-select.sh $ENDPOINT queries/sparql/data/digital-objects-per-organ.rq | csvsort -c organ > data/data/digital-objects-per-organ.csv

curl -L $HRALIT_PUBS | zcat | csvcut -c pmid,pubyear | csvsort -c pubyear -r | csvformat > data/data/hra-growth.hra-lit.csv

echo "doi,created" > data/data/hra-growth.sop.csv
curl $SOPs1 | jq -r '.hits.hits[] | [.conceptdoi,.created] | @csv' | csvsort -c 2 -r | csvformat >> data/data/hra-growth.sop.csv
curl $SOPs2 | jq -r '.hits.hits[] | [.conceptdoi,.created] | @csv' | csvsort -c 2 -r | csvformat >> data/data/hra-growth.sop.csv

src/cli/sparql-select.sh $ENDPOINT queries/sparql/data/hra-growth.atlas.rq > data/data/hra-growth.atlas.csv
src/cli/sparql-select.sh $ENDPOINT queries/sparql/data/hra-growth.experimental.rq > data/data/hra-growth.experimental.csv

node src/data/combine-growth-data.js
