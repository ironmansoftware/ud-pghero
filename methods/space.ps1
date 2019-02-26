function Get-DatabaseSize {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SELECT pg_database_size(current_database())
    "
}

function Get-RelationSize {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
    SELECT
        n.nspname AS schema,
        c.relname AS relation,
        CASE WHEN c.relkind = 'r' THEN 'table' ELSE 'index' END AS type,
        pg_table_size(c.oid) AS size_bytes
    FROM
        pg_class c
    LEFT JOIN
        pg_namespace n ON n.oid = c.relnamespace
    WHERE
        n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind IN ('r', 'i')
    ORDER BY
        pg_table_size(c.oid) DESC,
        2 ASC
    "
}

function Get-TableSize {
    Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
    SELECT
        n.nspname AS schema,
        c.relname AS table,
        pg_total_relation_size(c.oid) AS size_bytes
    FROM
        pg_class c
    LEFT JOIN
        pg_namespace n ON n.oid = c.relnamespace
    WHERE
        n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind = 'r'
    ORDER BY
        pg_total_relation_size(c.oid) DESC,
        2 ASC
    "
}