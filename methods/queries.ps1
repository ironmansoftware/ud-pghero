function Get-RunningQueries {
    param(
        [TimeSpan]$MinDuration,
        [Switch]$All
    )

    $MinDurationSecs = $MinDuration.TotalSeconds

    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT
            pid,
            state,
            application_name AS source,
            age(NOW(), COALESCE(query_start, xact_start)) AS duration,
            $(if ($script:server_version_num -ge 90600) { "(wait_event IS NOT NULL) AS waiting" } else { "waiting" }),
            query,
            COALESCE(query_start, xact_start) AS started_at,
            EXTRACT(EPOCH FROM NOW() - COALESCE(query_start, xact_start)) * 1000.0 AS duration_ms,
            usename AS user
        FROM
            pg_stat_activity
        WHERE
            state <> 'idle'
            AND pid <> pg_backend_pid()
            AND datname = current_database()
            $(if ($MinDurationSecs) { "AND NOW() - COALESCE(query_start, xact_start) > interval '$MinDurationSecs seconds'" })
            $(if ($null -eq $All) { "AND query <> '<insufficient privilege>'"})
        ORDER BY
            COALESCE(query_start, xact_start) DESC
    "
}

function Get-LongRunningQueries {
    Get-RunningQueries -MinDuration $Script:LongRunningQuerySec
}

function Get-BlockedQueries {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
    SELECT
        COALESCE(blockingl.relation::regclass::text,blockingl.locktype) as locked_item,
        blockeda.pid AS blocked_pid,
        blockeda.usename AS blocked_user,
        blockeda.query as blocked_query,
        age(now(), blockeda.query_start) AS blocked_duration,
        blockedl.mode as blocked_mode,
        blockinga.pid AS blocking_pid,
        blockinga.usename AS blocking_user,
        blockinga.state AS state_of_blocking_process,
        blockinga.query AS current_or_recent_query_in_blocking_process,
        age(now(), blockinga.query_start) AS blocking_duration,
        blockingl.mode as blocking_mode
    FROM
        pg_catalog.pg_locks blockedl
    LEFT JOIN
        pg_stat_activity blockeda ON blockedl.pid = blockeda.pid
    LEFT JOIN
        pg_catalog.pg_locks blockingl ON blockedl.pid != blockingl.pid AND (
        blockingl.transactionid = blockedl.transactionid
        OR (blockingl.relation = blockedl.relation AND blockingl.locktype = blockedl.locktype)
        )
    LEFT JOIN
        pg_stat_activity blockinga ON blockingl.pid = blockinga.pid AND blockinga.datid = blockeda.datid
    WHERE
        NOT blockedl.granted
        AND blockeda.query <> '<insufficient privilege>'
        AND blockeda.datname = current_database()
    ORDER BY
        blocked_duration DESC
    "
}