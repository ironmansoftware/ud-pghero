function Enable-QueryStats {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
    " -CUD
}

function Reset-QueryStats {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT pg_stat_statements_reset();
    " -CUD
}

function Test-QueryStatsEnabled {
    Test-QueryStatsReadable
}

function Test-QueryStatsReadable {
    try {
        Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
            SELECT * FROM pg_stat_statements LIMIT 1;
        "
        $true
    }
    catch {
        $false
    }   
}

function Get-CurrentQueryStats {
    param(
        [int]$Limit = 100,
        [string]$Sort = "total_minutes",
        $Database, 
        $QueryHash
    )

    if (Test-QueryStatsEnabled) {
        $Sql = "
        WITH query_stats AS (
            SELECT
            LEFT(query, 10000) AS query,
            $(if ($Script:server_version_num -ge 90400) { "queryid" } else { "md5(query)"}) AS query_hash,
            rolname AS user,
            (total_time / 1000 / 60) AS total_minutes,
            (total_time / calls) AS average_time,
            calls
            FROM
            pg_stat_statements
            INNER JOIN
            pg_database ON pg_database.oid = pg_stat_statements.dbid
            INNER JOIN
            pg_roles ON pg_roles.oid = pg_stat_statements.userid
            WHERE
            pg_database.datname = $(if($database) { "'$database'" } else { "current_database()" } )
            $(if ($query_hash) { "AND queryid = '$query_hash'" })
        )
        SELECT
            query,
            query_hash,
            query_stats.user,
            total_minutes,
            average_time,
            calls,
            total_minutes * 100.0 / (SELECT SUM(total_minutes) FROM query_stats) AS total_percent,
            (SELECT SUM(total_minutes) FROM query_stats) AS all_queries_total_minutes
        FROM
            query_stats
        ORDER BY
            $sort DESC
        LIMIT $limit
        "

        Write-UDLog -Message $Sql

        Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql $Sql

    }
}