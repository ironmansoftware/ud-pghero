Get-ChildItem (Join-Path $PSScriptRoot "methods") | ForEach-Object {
    . $_.FullName
}

function Start-UDPostgreSQLDashboard {
    param(
        $ConnectionString = "Server=127.0.0.1;Port=5432;",
        [TimeSpan]$LongRunningQuerySec = [TimeSpan]::FromSeconds(60),
        $Port = 1000
    )

    $Script:LongRunningQuerySec = $LongRunningQuerySec
    $Script:ConnectionString = $ConnectionString
    [int]$Script:server_version_num = Get-ServerVersionNumber 

    $Pages = Get-ChildItem (Join-Path $PSScriptRoot "Pages") | ForEach-Object {
        . $_.FullName
    }

    Enable-QueryStats

    $EndpointInit = New-UDEndpointInitialization -Function @(
        "Get-ConnectionCount"
        "Get-ConnectionStates"
        "Get-ConnectionSources"
        "Get-RelationSize"
        "Get-DatabaseSize"
        "Get-CurrentQueryStats"
        "Test-QueryStatsEnabled"
        "Test-QueryStatsReadable"
        "Get-MaintenanceInfo"
        "Get-Settings"
        "Get-LongRunningQueries"
        "Get-RunningQueries"
        "Reset-QueryStats"
    ) -Variable @("ConnectionString", "server_version_num", "LongRunningQuerySec")

    $Dashboard = New-UDDashboard -Title "UD PGHero" -Pages $Pages -EndpointInitialization $EndpointInit

    Start-UDDashboard -Dashboard $Dashboard -Port $Port -Design
}