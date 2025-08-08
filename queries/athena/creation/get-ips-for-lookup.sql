SELECT DISTINCT ip
FROM (
    SELECT c_ip as ip FROM "default"."old_logs"
    UNION ALL
    SELECT x_forwarded_for as ip FROM "default"."old_logs"
)
ORDER BY ip;
