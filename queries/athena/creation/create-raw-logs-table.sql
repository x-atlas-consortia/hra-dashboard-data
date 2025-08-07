CREATE EXTERNAL TABLE `default`.`raw_logs` (
  `date` string,
  `time` string,
  `x_edge_location` string,
  `sc_bytes` string,
  `cs_method` string,
  `cs_uri_stem` string,
  `sc_status` string,
  `cs_Referer` string,
  `cs_User_Agent` string,
  `cs_uri_query` string,
  `cs_Cookie` string,
  `x_edge_result_type` string,
  `x_edge_request_id` string,
  `x_host_header` string,
  `cs_protocol` string,
  `cs_bytes` string,
  `time_taken` string,
  `ssl_protocol` string,
  `ssl_cipher` string,
  `x_edge_response_result_type` string,
  `cs_protocol_version` string,
  `time_to_first_byte` string,
  `x_edge_detailed_result_type` string,
  `sc_content_type` string,
  `sc_content_len` string,
  `sc_range_start` string,
  `sc_range_end` string,
  `timestamp` string,
  `timestamp_ms` string,
  `c_country` string
)
PARTITIONED BY(
	distribution string,
	year int,
	month int,
	day int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS
  INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION 's3://hra-cdn-logs/raw_logs/'
TBLPROPERTIES (
  'parquet.compression' = 'SNAPPY',
  'projection.distribution.type' = 'enum',
  'projection.distribution.values' = 'purl,humanatlas.io,cdn,ccf-ontology,apps,docs.humanatlas.io,lod',
  'projection.day.range' = '01,31',
  'projection.day.type' = 'integer',
  'projection.day.digits' = '2',
  'projection.enabled' = 'true',
  'projection.month.range' = '01,12',
  'projection.month.type' = 'integer',
  'projection.month.digits' = '2',
  'projection.year.range' = '2023,2030',
  'projection.year.type' = 'integer',
  'storage.location.template' = 's3://hra-cdn-logs/raw_logs/${distribution}/year=${year}/month=${month}/day=${day}/'
);