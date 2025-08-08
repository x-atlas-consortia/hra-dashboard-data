CREATE TABLE "default"."old_raw_logs" WITH (
		format = 'PARQUET',
		external_location = 's3://hra-cdn-logs/old_raw_logs/',
		write_compression = 'SNAPPY'
	) AS
SELECT DISTINCT
  CAST(to_iso8601("date") AS varchar) as "date",
  "time",
  "x_edge_location",
  CAST("sc_bytes" AS varchar) AS "sc_bytes",
  "cs_method",
  "cs_uri_stem",
  CAST("sc_status" AS varchar) AS "sc_status",
  "cs_referrer" AS "cs_Referer",
  "cs_user_agent" AS "cs_User_Agent",
  "cs_uri_query",
  "cs_cookie" AS "cs_Cookie",
  "x_edge_result_type",
  "x_edge_request_id",
  "x_host_header",
  "cs_protocol",
  CAST("cs_bytes" AS varchar) AS "cs_bytes",
  CAST("time_taken" AS varchar) AS "time_taken",
  "ssl_protocol",
  "ssl_cipher",
  "x_edge_response_result_type",
  "cs_protocol_version",
  CAST("time_to_first_byte" AS varchar) AS "time_to_first_byte",
  "x_edge_detailed_result_type",
  "sc_content_type",
  CAST("sc_content_len" AS varchar) AS "sc_content_len",
  CAST("sc_range_start" AS varchar) AS "sc_range_start",
  CAST("sc_range_end" AS varchar) AS "sc_range_end",
  CAST(CAST(to_unixtime(CAST(to_iso8601("date") || ' ' || "time" AS TIMESTAMP)) AS BIGINT) AS varchar) AS "timestamp",
  CAST(CAST(to_unixtime(CAST(to_iso8601("date") || ' ' || "time" AS TIMESTAMP)) * 1000 AS BIGINT) AS varchar) AS "timestamp_ms",
  COALESCE("c1"."country", "c2"."country", '-') AS "c_country",
  "c_ip",
  "x_forwarded_for",
  "distribution",
  CAST(year(date) AS int) AS year,
  CAST(month(date) AS int) AS month,
  CAST(day(date) AS int) AS day
FROM "default"."old_logs"
LEFT OUTER JOIN "default"."ip_country_lookup" AS "c1" ON
    ("c1"."country" != '-' AND "default"."old_logs"."c_ip" = "c1"."ip")
LEFT OUTER JOIN "default"."ip_country_lookup" AS "c2" ON 
    ("c2"."country" != '-' AND "default"."old_logs"."x_forwarded_for" = "c2"."ip")
ORDER BY "timestamp";
