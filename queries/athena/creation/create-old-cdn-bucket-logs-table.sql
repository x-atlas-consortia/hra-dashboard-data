CREATE EXTERNAL TABLE `default`.`cdn_bucket_logs` (
  `bucketowner` string, 
  `bucket_name` string, 
  `requestdatetime` string, 
  `remoteip` string, 
  `requester` string, 
  `requestid` string, 
  `operation` string, 
  `key` string, 
  `request_uri` string, 
  `httpstatus` string, 
  `errorcode` string, 
  `bytessent` BIGINT, 
  `objectsize` BIGINT, 
  `totaltime` string, 
  `turnaroundtime` string, 
  `referrer` string, 
  `useragent` string, 
  `versionid` string, 
  `hostid` string, 
  `sigv` string, 
  `ciphersuite` string, 
  `authtype` string, 
  `endpoint` string, 
  `tlsversion` string,
  `accesspointarn` string,
  `aclrequired` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.RegexSerDe' 
WITH SERDEPROPERTIES ( 
  'input.regex'='([^ ]*) ([^ ]*) \\[(.*?)\\] ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) (\"[^\"]*\"|-) (-|[0-9]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) (\"[^\"]*\"|-) ([^ ]*)(?: ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*))?.*$') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://hra-cdn-logs/cdn-bucket/'
