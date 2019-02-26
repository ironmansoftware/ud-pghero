New-UDPage -Name "Connections" -Icon plug -Endpoint {

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            $ConnectionCount = Get-ConnectionCount
            New-UDHeading -Text "Connections"-Size 3
            New-UDHeading -Text "$ConnectionCount connections"-Size 5
        }
    }

    $Sources = (Get-ConnectionSources) | Where-Object { $_.database -isnot [DBNull] }

    $ByDatabase = $Sources | ForEach-Object {
        [PSCustomObject]@{
            id = $_.database
            label = $_.database
            value = $_.total_connections
        }
    }

    $ByUser = $Sources | ForEach-Object {
        [PSCustomObject]@{
            id = $_.user
            label = $_.user
            value = $_.total_connections
        }
    }

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 3 -LargeOffset 3 -Content {
            New-UDChart -Type Pie -Title "By Database" -Endpoint {
                $ByDatabase | Out-UDChartData -DataProperty "value" -LabelProperty 'label'
            }
        }
        New-UDColumn -SmallSize 12 -LargeSize 3 -Content {
            New-UDChart -Type Pie -Title "By User" -Endpoint {
                $ByUser | Out-UDChartData -DataProperty "value" -LabelProperty 'label'
            }
        }
    }

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDTable -Title 'Top Sources' -Headers @("Top Sources", "Connections") -Endpoint {
                $Sources | ForEach-Object {
                    [PSCustomObject]@{
                        TopSource = $_.source + [Environment]::NewLine + "$($_.user)   $($_.database)    $($_.ip)"
                        Connections = $_.total_connections
                    }
                } | Out-UDTableData -Property @("TopSource", "Connections")
            }
        }
    }
}