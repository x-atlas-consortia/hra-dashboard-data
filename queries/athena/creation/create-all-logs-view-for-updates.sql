CREATE VIEW "default"."all_logs_view" AS
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
            kv -> coalesce(try(url_decode(url_decode(split(kv, '=')[2]))), '')
        )
    )), map())
  END AS query,
  CASE
    WHEN LOWER(cs_user_agent) LIKE '%gptbot%' THEN 'AI-Assistant / Bot'
    WHEN LOWER(cs_user_agent) LIKE '%openai%' THEN 'AI-Assistant / Bot'
    WHEN LOWER(cs_user_agent) LIKE '%anthropic%' THEN 'AI-Assistant / Bot'
    WHEN LOWER(cs_user_agent) LIKE '%claude%' THEN 'AI-Assistant / Bot'
    WHEN LOWER(cs_user_agent) LIKE '%crawler%' THEN 'Bot'
    WHEN LOWER(cs_user_agent) LIKE '%spider%' THEN 'Bot'
    WHEN LOWER(cs_user_agent) LIKE '%bot%' THEN 'Bot'
    ELSE 'Likely Human'
  END AS traffic_type,
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
FROM "default"."raw_logs" -- WHERE CAST("date" as DATE) >= date("2025-08-08")
CROSS JOIN analytics_salt
ORDER BY "timestamp_ms"
