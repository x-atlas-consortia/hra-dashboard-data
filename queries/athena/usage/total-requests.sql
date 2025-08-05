SELECT "label", "count"
FROM (
  SELECT 'HRA-API requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."all_logs" WHERE "site" = 'API'
  UNION ALL
  SELECT 'HRA Portal requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."all_logs" WHERE "site" = 'Portal'
  UNION ALL
  SELECT 'HRA KG requests' as "label", CAST(COUNT(*) as integer) AS "count" FROM "default"."all_logs" WHERE "site" = 'KG'
)
