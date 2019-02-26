function Get-ServerVersionNumber {
    (Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
        SHOW server_version_num;
    ").server_version_num
}