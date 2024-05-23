#!/bin/bash
shopt -s extglob
set -ev

ENDPOINT=https://lod.humanatlas.io/sparql

src/cli/sparql-select.sh $ENDPOINT queries/sparql/data/digital-objects-per-organ.rq | csvsort -c organ > data/data/digital-objects-per-organ.csv
