CREATE TABLE "default"."all_logs" WITH (
		format = 'PARQUET',
		external_location = 's3://hra-cdn-logs/all_logs/',
		write_compression = 'SNAPPY',
		partitioned_by = ARRAY['site', 'year']
	) AS
SELECT
  CASE
    WHEN "c_ip" != '-' THEN to_base64url(substr(sha256(CAST(CONCAT("c_ip", "salt_string") AS varbinary)), 1, 16))
    WHEN "x_forwarded_for" != '-' THEN to_base64url(substr(sha256(CAST(CONCAT("x_forwarded_for", "salt_string") AS varbinary)), 1, 16))
    ELSE '-'
  END AS anon_id,
  CAST("date" AS DATE) AS "date",
  "time",
  "x_edge_location",
  CAST("sc_bytes" as BIGINT) AS "sc_bytes",
  "cs_method",
  "cs_uri_stem",
  CAST("sc_status" as INT) AS "sc_status",
  "cs_Referer",
  "cs_User_Agent",
  "cs_uri_query",
  "cs_Cookie",
  "x_edge_result_type",
  "x_edge_request_id",
  "x_host_header",
  "cs_protocol",
  CAST("cs_bytes" as BIGINT) AS "cs_bytes",
  CAST("time_taken" as DOUBLE) AS "time_taken",
  "ssl_protocol",
  "ssl_cipher",
  "x_edge_response_result_type",
  "cs_protocol_version",
  CAST("time_to_first_byte" as DOUBLE) AS "time_to_first_byte",
  "x_edge_detailed_result_type",
  "sc_content_type",
  TRY(CAST("sc_content_len" as BIGINT)) AS "sc_content_len",
  TRY(CAST("sc_range_start" as BIGINT)) AS "sc_range_start",
  TRY(CAST("sc_range_end" as BIGINT)) AS "sc_range_end",
  CAST("timestamp" as BIGINT) AS "timestamp",
  CAST("timestamp_ms" as BIGINT) AS "timestamp_ms",
  "c_country",
  CASE
    WHEN cs_uri_query = '-' THEN map()
    ELSE coalesce(try(map(
        transform(
            split(cs_uri_query, '&'),
            kv -> split(kv, '=')[1]
        ),
        transform(
            split(cs_uri_query, '&'),
            kv -> coalesce(try(split(kv, '=')[2]), '')
        )
    )), map())
  END AS query,
  COALESCE(url_extract_host("cs_Referer"), '') as "referrer",
  CAST(substr("x_edge_location", 1, 3) AS varchar) as "airport",
  "month",
  "day",
  "distribution",
  CAST(CASE
    WHEN "distribution" = 'humanatlas.io' AND "cs_uri_stem" NOT IN ('/tr', '/tr-dev') THEN 'Portal'
    WHEN "distribution" = 'docs.humanatlas.io' THEN 'Portal'
    WHEN "distribution" = 'apps' AND "cs_uri_stem" LIKE '%api%' THEN 'API'
    WHEN "distribution" = 'apps' AND "cs_uri_stem" NOT LIKE '%api%' THEN 'Apps'
    WHEN "distribution" = 'ccf-ontology' THEN 'KG'
    WHEN "distribution" = 'cdn' AND "cs_uri_stem" NOT LIKE '/digital-objects/%' AND "cs_uri_stem" NOT IN ('/tr', '/tr-dev') THEN 'CDN'
    WHEN "distribution" = 'cdn' AND "cs_uri_stem" LIKE '/digital-objects/%' AND "cs_uri_stem" NOT IN ('/tr', '/tr-dev') THEN 'KG'
    WHEN "distribution" = 'lod' THEN 'KG'
    WHEN "distribution" = 'purl' THEN 'KG'
    WHEN "distribution" = 'humanatlas.io' AND "cs_uri_stem" IN ('/tr', '/tr-dev') THEN 'Events'
    WHEN "distribution" = 'cdn' AND "cs_uri_stem" IN ('/tr', '/tr-dev') THEN 'Events'
    ELSE "distribution"
  END AS varchar) AS "site",
  "year"
FROM (
  SELECT * FROM "default"."old_raw_logs" WHERE CAST("date" as DATE) < date('2025-08-10')
  UNION ALL
  SELECT * FROM "default"."raw_logs" WHERE CAST("date" as DATE) >= date('2025-08-10')
)
CROSS JOIN
  analytics_salt
WHERE CAST("date" as DATE) <= CAST(current_date - interval '1' day AS date)
ORDER BY "timestamp_ms";
