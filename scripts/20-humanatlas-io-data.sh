#!/bin/bash
shopt -s extglob
set -ev

ENDPOINT=https://lod.humanatlas.io/sparql
# ENDPOINT=http://localhost:8080/blazegraph/namespace/kb/sparql

./src/cli/sparql-select.sh $ENDPOINT queries/sparql/humanatlas.io/ref-organs.rq > data/humanatlas.io/ref-organs.csv
csvjson -I data/humanatlas.io/ref-organs.csv | yq -y "$(cat queries/sparql/humanatlas.io/ref-organs.jqx)" > data/humanatlas.io/ref-organs.yaml

./src/cli/sparql-select.sh $ENDPOINT queries/sparql/humanatlas.io/ftu-illustrations.rq > data/humanatlas.io/ftu-illustrations.csv
csvjson -I data/humanatlas.io/ftu-illustrations.csv | yq -y "$(cat queries/sparql/humanatlas.io/ftu-illustrations.jqx)" > data/humanatlas.io/ftu-illustrations.yaml

./src/cli/sparql-select.sh $ENDPOINT queries/sparql/humanatlas.io/as-per-organ.rq > data/humanatlas.io/as-per-organ.csv
./src/cli/sparql-select.sh $ENDPOINT queries/sparql/humanatlas.io/asctb-release.rq > data/humanatlas.io/asctb-release.csv
./src/cli/sparql-select.sh $ENDPOINT queries/sparql/humanatlas.io/omaps-release.rq > data/humanatlas.io/omaps-release.csv
