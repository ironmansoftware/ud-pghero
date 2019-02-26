# UD-PGHero

## [PGHero](https://github.com/ankane/pghero) clone built in PowerShell and on [Universal Dashboard](https://ironmansoftware.com/powershell-universal-dashboard/)

# Usage

```
Import-Module ud-pghero
Start-UDPostgreSQLDashboard -ConnectionString "Server=localhost;Port=5432;User Id=pgadmin;Password=pgadmin" -Port 1000
```

# Connections

## View active connections group by user and database. View top sources. 

![](./images/connections.png)

# Maintenance

## View last vacuum and analyze runs for tables. 

![](./images/maintenance.png)

# Queries

## View queries stats.

![](./images/queries.png)

# Space

## View relation space

![](./images/space.png)

# Tune

## View various tuning settings.

![](./images/tune.png)