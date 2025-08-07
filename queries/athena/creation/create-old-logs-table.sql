CREATE EXTERNAL TABLE `default`.`old_logs` (
  `date` DATE,
  `time` string,
  `x_edge_location` string,
  `sc_bytes` BIGINT,
  `c_ip` string,
  `cs_method` string,
  `cs_host` string,
  `cs_uri_stem` string,
  `sc_status` INT,
  `cs_referrer` string,
  `cs_user_agent` string,
  `cs_uri_query` string,
  `cs_cookie` string,
  `x_edge_result_type` string,
  `x_edge_request_id` string,
  `x_host_header` string,
  `cs_protocol` string,
  `cs_bytes` BIGINT,
  `time_taken` FLOAT,
  `x_forwarded_for` string,
  `ssl_protocol` string,
  `ssl_cipher` string,
  `x_edge_response_result_type` string,
  `cs_protocol_version` string,
  `fle_status` string,
  `fle_encrypted_fields` INT,
  `c_port` INT,
  `time_to_first_byte` FLOAT,
  `x_edge_detailed_result_type` string,
  `sc_content_type` string,
  `sc_content_len` BIGINT,
  `sc_range_start` BIGINT,
  `sc_range_end` BIGINT
)
PARTITIONED BY(
  distribution string
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
LOCATION 's3://hra-cdn-logs/{distribution}/'
TBLPROPERTIES (
  'skip.header.line.count' = '2',
  'projection.enabled' = 'true',
  'projection.distribution.type' = 'enum',
  'projection.distribution.values' = 'purl,humanatlas.io,cdn,ccf-ontology,apps,docs.humanatlas.io,lod',
  'storage.location.template' = 's3://hra-cdn-logs/${distribution}/'
);
