INSERT INTO "default"."all_logs"
SELECT * 
FROM "default"."all_logs_view"
WHERE
  "date" > (SELECT MAX("date") FROM "default"."all_logs")
  AND "date" <= CAST(current_date - interval '1' day AS DATE);

-- Add all events newer than what's stored on all_logs up to the previous day
-- Add all events newer than what's stored on all_logs
-- WHERE "timestamp_ms" > (SELECT MAX("timestamp_ms") FROM "default"."all_logs")
