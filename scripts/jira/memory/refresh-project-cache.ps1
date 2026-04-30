#requires -Version 5.1
[CmdletBinding()]
param()
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
. (Join-Path $PSScriptRoot 'JiraMemoryStore.ps1')
$s = New-JiraToolkitSession
$start = 0
$acc = [System.Collections.ArrayList]::new()
while ($true) {
    $page = $s.Projects.List(@{ startAt = $start; maxResults = 50; orderBy = 'name' })
    foreach ($p in $page.values) { [void]$acc.Add($p) }
    $start += $page.values.Count
    if ($page.isLast -eq $true -or $page.values.Count -eq 0) { break }
    if ($null -ne $page.total -and $start -ge $page.total) { break }
}
$store = [JiraMemoryStore]::new($PSScriptRoot)
$store.WriteProjects(@{ updatedAt = (Get-Date).ToString('o'); projects = @($acc) })
Write-Host "Cached $($acc.Count) projects."
