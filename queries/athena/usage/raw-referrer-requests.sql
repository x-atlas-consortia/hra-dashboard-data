SELECT "date", "referrer" as "host", CAST(COUNT(*) as integer) AS "requests"
FROM "default"."all_logs"
GROUP BY "referrer", "date"
ORDER BY "referrer", "date"
