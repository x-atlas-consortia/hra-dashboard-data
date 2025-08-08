CREATE EXTERNAL TABLE `default`.`ip_country_lookup` (
    `ip` STRING,
    `country` STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   'separatorChar' = ',',
   'quoteChar' = '"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE
LOCATION 's3://hra-cdn-logs/ip-country-lookup/';
