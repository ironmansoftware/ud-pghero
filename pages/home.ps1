New-UDPage -Name "Overview" -Icon home -DefaultHomePage -Endpoint {
    $LongRunningQueries = Get-LongRunningQueries

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDHeading -Text "$($LongRunningQueries.Length) long running queries" -Size 4
        }
    }

    if ($LongRunningQueries.Length -gt 0) {
        foreach($Query in $LongRunningQueries) {
            New-UDCard -Title "Long Running Queries" -Content {
                New-UDHeading -Text "Duration: $([TimeSpan]::FromMilliseconds($_.duration_ms))"
                New-UDHeading -Text $_.query
           }
        }
    } 
}