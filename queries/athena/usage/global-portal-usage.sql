SELECT "airport", "c_country" AS "country", CAST(COUNT(*) as integer) AS "requests",
    MIN("date") as start_date,
	MAX("date") AS end_date,
	CAST(day(MAX("date") - MIN("date")) as integer) AS days
FROM (
    SELECT "airport", "c_country", "date" FROM "default"."all_logs" WHERE site = 'Portal'
)
GROUP BY "airport", "c_country"
ORDER BY "requests" DESC
