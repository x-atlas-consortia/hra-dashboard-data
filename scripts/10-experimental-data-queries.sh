#!/bin/bash
shopt -s extglob
set -ev

ENDPOINT=https://lod.humanatlas.io/sparql
HRAPOP_ENDPOINT=http://localhost:8080/blazegraph/namespace/kb/sparql

src/cli/sparql-select.sh $HRAPOP_ENDPOINT queries/sparql/experimental-data/hra-pop-mapped-to-hra.rq > data/experimental-data/hra-pop-mapped-to-hra.csv
src/cli/sparql-select.sh $HRAPOP_ENDPOINT queries/sparql/experimental-data/hra-pop-atlas-mapped-to-hra.rq > data/experimental-data/hra-pop-atlas-mapped-to-hra.csv
