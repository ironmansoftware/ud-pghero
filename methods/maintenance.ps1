function Get-MaintenanceInfo {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT
            schemaname AS schema,
            relname AS table,
            last_vacuum,
            last_autovacuum,
            last_analyze,
            last_autoanalyze
        FROM
            pg_stat_user_tables
        ORDER BY
            1, 2
    "
}