SELECT "label", "count"
FROM (
  SELECT 'HRA-API requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."apps_logs" WHERE "cs_uri_stem" LIKE '%api%'
  UNION ALL
  SELECT 'HRA Portal requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."humanatlas_io_logs"
)
