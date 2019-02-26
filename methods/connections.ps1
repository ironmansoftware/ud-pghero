function Get-ConnectionCount {
    (Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT COUNT(*) as count FROM pg_stat_activity
    ")[0].count
}

function Get-ConnectionStates {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT
            state,
            COUNT(*) AS connections
        FROM
            pg_stat_activity
        GROUP BY
            1
        ORDER BY
            2 DESC, 1
    "
}

function Get-ConnectionSources {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
    SELECT
        datname AS database,
        usename AS user,
        application_name AS source,
        client_addr AS ip,
        COUNT(*) AS total_connections
    FROM
        pg_stat_activity
    GROUP BY
        1, 2, 3, 4
    ORDER BY
        5 DESC, 1, 2, 3, 4
    "
}