INSERT INTO "default"."all_logs"
SELECT * 
FROM "default"."all_logs_view"
WHERE
  "date" > (SELECT MAX("date") FROM "default"."all_logs")
  AND "date" <= CAST(current_date - interval '1' day AS DATE);
