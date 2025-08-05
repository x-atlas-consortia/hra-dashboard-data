SELECT "site", "date", CAST(COUNT(*) AS integer) AS "requests"
FROM "default"."all_logs"
WHERE "date" IS NOT NULL
GROUP BY "site", "date"
ORDER BY "date"
