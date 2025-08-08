#!/bin/bash

# CONFIGURATION
BUCKET="hra-cdn-logs"
KEY="salt/salt.csv"                    # Relative path in bucket
SALT_LENGTH=24                         # Length of salt string (in characters)

# Generate a new random salt (alphanumeric)
SALT=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c $SALT_LENGTH)

# Create CSV content
echo "salt_string" > salt.csv
echo "$SALT" >> salt.csv

# Upload to S3 (overwrite existing salt)
aws s3 cp salt.csv "s3://$BUCKET/$KEY" --acl bucket-owner-full-control

# Clean up temp file
rm salt.csv

echo "✅ Salt rotated and uploaded successfully."
echo "🧂 New salt: $SALT"
