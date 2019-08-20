New-UDPage -Name "Queries" -Icon question_circle -Endpoint {

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDButton -Text "Reset Query Stats" -OnClick {
                Reset-QueryStats
            }
        }
    }

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            $Queries = Get-CurrentQueryStats  
            $Queries | ForEach-Object {
                New-UDCard -Title "Total Minutes: $($_.total_minutes.ToString('F4'))   Average Time: $($_.average_time.ToString('F1'))   Calls: $($_.calls)" -Content {
                    $_.query
                }
            }
        }
    }
}