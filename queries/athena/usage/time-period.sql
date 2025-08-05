SELECT
  MIN("date") as start_date,
	MAX("date") AS end_date,
	CAST(day(MAX("date") - MIN("date")) as integer) AS days
FROM "default"."all_logs"

