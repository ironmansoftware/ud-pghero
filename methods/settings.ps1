function Get-Settings {

    if ($script:server_version_num -gt 90500) {
        $Settings = @("max_connections", "shared_buffers", "effective_cache_size", "work_mem", "maintenance_work_mem", "min_wal_size", "max_wal_size", "checkpoint_completion_target", "wal_buffers", "default_statistics_target")
    }
    else {
        $Settings = @("max_connections", "shared_buffers", "effective_cache_size", "work_mem", "maintenance_work_mem", "checkpoint_segments", "checkpoint_completion_target", "wal_buffers", "default_statistics_target")
    }

    foreach($setting in $Settings) {
        [PSCustomObject]@{
            name = $Setting
            value = (Invoke-PostgreSqlQuery -ConnectionString $Script:ConnectionString -Sql "
                SHOW $setting
            ")[0].Item(0)
        }
        
    }
}