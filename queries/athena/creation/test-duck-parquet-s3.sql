INSTALL httpfs;

CREATE OR REPLACE SECRET secret (
    TYPE s3,
    PROVIDER credential_chain
);

CREATE TABLE raw_logs AS
SELECT *
FROM read_parquet('s3://hra-cdn-logs/raw_logs/**/*',
  hive_partitioning = true,
  hive_types = {'DistributionId': VARCHAR, 'year': INT, 'month': INT, 'day': INT }
);
