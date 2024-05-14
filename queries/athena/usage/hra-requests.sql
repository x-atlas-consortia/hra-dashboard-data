SELECT "site", "date", CAST(COUNT(*) AS integer) AS "requests"
FROM (
  SELECT 'Portal' as "site", "date" FROM "default"."humanatlas_io_logs"
  UNION ALL
  SELECT 'API' as "site", "date" FROM "default"."apps_logs" WHERE "cs_uri_stem" LIKE '%api%'
  UNION ALL
  SELECT 'Apps' as "site", "date" FROM "default"."apps_logs" WHERE "cs_uri_stem" NOT LIKE '%api%'
  UNION ALL
  SELECT 'KG' as "site", "date" FROM "default"."ccf_ontology_logs"
  UNION ALL
  SELECT 'CDN' as "site", "date" FROM "default"."cdn_logs"
  UNION ALL
  SELECT 'CDN' as "site", "date" FROM "default"."cdn_bucket_logs"
  UNION ALL
  SELECT 'KG' as "site", "date" FROM "default"."lod_logs"
  UNION ALL
  SELECT 'KG' as "site", "date" FROM "default"."purl_logs"  
)
WHERE "date" IS NOT NULL
GROUP BY "site", "date"
ORDER BY "date"
