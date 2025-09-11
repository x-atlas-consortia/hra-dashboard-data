INSTALL httpfs;

CREATE OR REPLACE SECRET secret (
    TYPE s3,
    PROVIDER credential_chain
);

CREATE TABLE all_logs AS
SELECT *
FROM read_parquet('s3://hra-cdn-logs/all_logs/**/*',
  hive_partitioning = true,
  hive_types = {'site': VARCHAR, 'year': INT }
);

COPY all_logs TO 'hra-logs.parquet' (FORMAT parquet, COMPRESSION zstd);

COPY (SELECT * FROM all_logs ORDER BY "date" DESC) TO 'hra-logs.csv.gz'
