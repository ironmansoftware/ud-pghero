New-UDPage -Name "Tune" -Icon dashboard -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDTable -Title "Settings" -Headers @("Name", "Value") -Endpoint {
                $Settings = Get-Settings
                $Settings | Out-UDTableData -Property @("Name", "Value")
            }
        }
    }
}