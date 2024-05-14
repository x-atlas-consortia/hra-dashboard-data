SELECT
  MIN("date") as start_date,
	MAX("date") AS end_date,
	CAST(day(MAX("date") - MIN("date")) as integer) AS days
FROM (
  SELECT "date" FROM "default"."humanatlas_io_logs"
  UNION ALL
  SELECT "date" FROM "default"."apps_logs"
  UNION ALL
  SELECT "date" FROM "default"."ccf_ontology_logs"
  UNION ALL
  SELECT "date" FROM "default"."cdn_bucket_logs"
  UNION ALL
  SELECT "date" FROM "default"."cdn_logs"
  UNION ALL
  SELECT "date" FROM "default"."lod_logs"
  UNION ALL
  SELECT "date" FROM "default"."purl_logs"
)
