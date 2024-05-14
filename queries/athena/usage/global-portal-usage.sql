SELECT "airport", "ip", CAST(COUNT(*) as integer) AS "requests",
    MIN("date") as start_date,
	MAX("date") AS end_date,
	CAST(day(MAX("date") - MIN("date")) as integer) AS days
FROM (
    SELECT substr("x_edge_location", 1, 3) as "airport", "c_ip" as "ip", "date" FROM "default"."humanatlas_io_logs"
)
GROUP BY "airport", "ip"
ORDER BY "requests" DESC
