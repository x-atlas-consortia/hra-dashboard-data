CREATE TABLE "default"."all_logs" WITH (
		format = 'PARQUET',
		external_location = 's3://hra-cdn-logs/all_logs/',
		write_compression = 'SNAPPY',
		partitioned_by = ARRAY['site', 'year', 'month']
	) AS
SELECT
    split(cs_uri_query, '&') AS cs_uri_query_parts,
    COALESCE(url_extract_host("cs_referrer"), '') as "referrer",
    substr("x_edge_location", 1, 3) as "airport",
    *,
    year(date) AS year,
    month(date) AS month
FROM (
  SELECT *, 'www' as distribution, 'Portal' as "site" FROM "default"."humanatlas_io_logs" AND "cs_uri_stem" NOT IN ('/tr', '/tr-dev')
  UNION ALL
  SELECT *, 'docs' as distribution, 'Portal' as "site" FROM "default"."docs_humanatlas_io_logs"
  UNION ALL
  SELECT *, 'apps' as distribution, 'API' as "site" FROM "default"."apps_logs" WHERE "cs_uri_stem" LIKE '%api%'
  UNION ALL
  SELECT *, 'apps' as distribution, 'Apps' as "site" FROM "default"."apps_logs" WHERE "cs_uri_stem" NOT LIKE '%api%'
  UNION ALL
  SELECT *, 'ccf' as distribution, 'KG' as "site" FROM "default"."ccf_ontology_logs"
  UNION ALL
  SELECT *, 'cdn' as distribution, 'CDN' as "site" FROM "default"."cdn_logs" WHERE "cs_uri_stem" NOT LIKE '/digital-objects/%' AND "cs_uri_stem" NOT IN ('/tr', '/tr-dev')
  UNION ALL
  SELECT *, 'cdn' as distribution, 'CDN' as "site" FROM "default"."cdn_bucket_logs"
  UNION ALL
  SELECT *, 'cdn' as distribution, 'KG' as "site" FROM "default"."cdn_logs" WHERE "cs_uri_stem" LIKE '/digital-objects/%'
  UNION ALL
  SELECT *, 'lod' as distribution, 'KG' as "site" FROM "default"."lod_logs"
  UNION ALL
  SELECT *, 'purl' as distribution, 'KG' as "site" FROM "default"."purl_logs"
  UNION ALL
  SELECT *, 'events' as distribution, 'Events' as "site" FROM "default"."humanatlas_io_logs" WHERE "cs_uri_stem" IN ('/tr', '/tr-dev')
)
WHERE date <= CAST(current_date - interval '1' day AS date);
