#!/bin/bash

echo Drop old all_logs table data in S3
aws s3 rm s3://hra-cdn-logs/all_logs --recursive

echo Drop the old all_logs table in Athena
node ./src/cli/athena-query.js queries/athena/creation/drop-all-logs-table.sql

echo Recreate the all_logs table with latest data
node ./src/cli/athena-query.js queries/athena/creation/create-all-logs-table.sql
