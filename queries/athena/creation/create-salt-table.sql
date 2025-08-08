CREATE EXTERNAL TABLE IF NOT EXISTS analytics_salt (
  salt_string STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ','
)
LOCATION 's3://hra-cdn-logs/salt/'
TBLPROPERTIES (
  'skip.header.line.count' = '1',
  'has_encrypted_data' = 'false'
);
