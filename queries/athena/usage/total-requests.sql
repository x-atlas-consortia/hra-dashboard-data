SELECT "label", "count"
FROM (
  SELECT 'HRA-API requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."apps_logs" WHERE "cs_uri_stem" LIKE '%api%'
  UNION ALL
  SELECT 'HRA Portal requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."humanatlas_io_logs"
  UNION ALL
  SELECT 'HRA KG requests' as "label", CAST(SUM("count") as integer) AS "count" FROM (
    SELECT CAST(COUNT(*) as integer) AS "count" FROM "default"."ccf_ontology_logs"
    UNION ALL
    SELECT CAST(COUNT(*) as integer) AS "count" FROM "default"."lod_logs"
    UNION ALL
    SELECT CAST(COUNT(*) as integer) AS "count" FROM "default"."purl_logs"
    UNION ALL
    SELECT CAST(COUNT(*) as integer) AS "count" FROM "default"."apps_logs" WHERE "cs_uri_stem" LIKE '%sparql%'
    UNION ALL
    SELECT CAST(COUNT(*) as integer) AS "count" FROM "default"."cdn_logs" WHERE "cs_uri_stem" LIKE '%digital-objects%'
  )
)
