New-UDPage -Name "Overview" -Icon home -DefaultHomePage -Endpoint {
    $LongRunningQueries = Get-LongRunningQueries

    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -LargeSize 6 -LargeOffset 3 -Content {
            New-UDHeading -Text "$($LongRunningQueries.Length) long running queries" -Size 4
        }
    }
}