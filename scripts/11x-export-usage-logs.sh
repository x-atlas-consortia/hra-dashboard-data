#!/bin/bash

duckdb -no-stdin -init queries/athena/creation/export-all-logs-table-duckdb.sql

YESTERDAY=$(date -Idate -d "yesterday")
mkdir -p scratch
BASE="scratch/${YESTERDAY}_hra-logs"
mv hra-logs.parquet ${BASE}.parquet
mv hra-logs.csv.gz ${BASE}.csv.gz
