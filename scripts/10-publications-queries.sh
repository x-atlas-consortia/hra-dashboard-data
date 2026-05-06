#!/bin/bash
shopt -s extglob
set -ev

node src/publications/publication-overlap-by-country.js
node src/publications/publication-overlap-by-year.js
