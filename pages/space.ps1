New-UDPage -Name "Space" -Icon folder -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -Content {
            New-UDHeading -Text "Space" -Size 3

            $DatabaseSize = ((Get-DatabaseSize).pg_database_size / 1MB).ToString('F1')
            New-UDHeading -Text "Database Size: $DatabaseSize MB" -Size 5

            New-UDTable -Title Relations -Headers @("Relation", "Size")  -Endpoint {
                $Items = Get-RelationSize
                $Items | ForEach-Object {
                    [PSCustomObject]@{
                        Relation = $_.Relation 
                        Size = "$(($_.size_bytes / 1MB).ToString('F1')) MB"
                    }
                } | Out-UDTableData -Property @("Relation", "Size")
            }
        }
    }
}