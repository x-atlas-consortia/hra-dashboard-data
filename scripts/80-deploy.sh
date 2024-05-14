#!/bin/bash
shopt -s extglob
set -ev

CLEAN="--delete"

aws s3 sync $CLEAN ./data/ s3://cdn-humanatlas-io/hra-dashboard-data/
