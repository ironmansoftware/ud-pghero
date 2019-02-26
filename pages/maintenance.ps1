New-UDPage -Name 'Maintenance' -Icon gear -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDTable -Title "Maintenance" -Headers @("Table", "Last Vacuum", "Last Analyze") -Endpoint {
                $Items = Get-MaintenanceInfo  
                $Items | ForEach-Object {

                    $lastVacuum = $null
                    if ($_.last_vacuum -is [DateTime]) {
                        $lastVacuum = $_.last_vacuum 
                    }

                    if (($lastVacuum -ne $null -and $_.last_autovacuum -is [DateTime] -and $_.last_autovacuum -gt $lastVacuum) -or ($_.last_autovacuum -is [DateTime] -and $lastVacuum -eq $null)) {
                        $lastVacuum = $_.last_autovacuum
                    }

                    if ($null -eq $lastVacuum) {
                        $lastVacuum = 'Unknown'
                    } else {
                        $lastVacuum = $lastVacuum
                    }
                    
                    $lastAnalyze = $null
                    if ($_.last_analyze -is [DateTime]) {
                        $lastAnalyze = $_.last_analyze 
                    }

                    if (($lastAnalyze -ne $null -and $_.last_autoanalyze -is [DateTime] -and $_.last_autoanalyze -gt $lastAnalyze) -or ($_.last_autoanalyze -is [DateTime] -and $lastAnalyze -eq $null)) {
                        $lastAnalyze = $_.last_autoanalyze
                    }

                    if ($null -eq $lastAnalyze) {
                        $lastAnalyze = 'Unknown'
                    } else {
                        $lastAnalyze = $lastAnalyze
                    }

                    [PSCustomObject]@{
                        Table = $_.table 
                        LastVacuum = $lastVacuum
                        LastAnalyze = $lastAnalyze
                    } | Out-UDTableData -Property @("Table", "LastVacuum", "LastAnalyze")
                }
            }
        }
    }
}