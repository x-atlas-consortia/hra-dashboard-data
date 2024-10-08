SELECT "host", CAST(COUNT(*) as integer) AS "requests"
FROM (
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."humanatlas_io_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."apps_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."ccf_ontology_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."cdn_bucket_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."cdn_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."lod_logs"
    UNION ALL
    SELECT COALESCE(url_extract_host("cs_referrer"), '') as "host" FROM "default"."purl_logs"
)
GROUP BY "host"
ORDER BY "requests" DESC
