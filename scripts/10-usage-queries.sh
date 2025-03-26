#!/bin/bash
shopt -s extglob
set -ev

node src/usage/global-portal-usage.js
sleep 5

node src/cli/athena-query.js queries/athena/usage/hra-requests.sql data/usage/hra-requests.csv
node src/cli/athena-query.js queries/athena/usage/raw-referrers.sql data/usage/raw-referrers.csv
node src/cli/athena-query.js queries/athena/usage/time-period.sql data/usage/time-period.csv
node src/usage/top-referrers.js
node src/cli/athena-query.js queries/athena/usage/total-requests.sql data/usage/total-requests.csv

node src/cli/athena-query.js queries/athena/usage/raw-referrer-requests.sql data/usage/raw-referrer-requests.csv
node src/usage/top-users.js
