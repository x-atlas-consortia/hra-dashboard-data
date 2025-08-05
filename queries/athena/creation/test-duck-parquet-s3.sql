INSTALL httpfs;

CREATE OR REPLACE SECRET secret (
    TYPE s3,
    PROVIDER credential_chain
);

SELECT *
FROM read_parquet('s3://hra-cdn-logs/all_logs/**/*',
  hive_partitioning = true,
  hive_types = {'site': VARCHAR, 'year': INT, 'month': INT }
)
WHERE site = 'Events' AND year = 2025 AND month = 8;
