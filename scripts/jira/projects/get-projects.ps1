#requires -Version 5.1
[CmdletBinding()]
param(
    [int]$MaxResults = 50,
    [string]$OrderBy = 'name',
    [string]$Query
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$start = 0
$acc = [System.Collections.ArrayList]::new()
while ($true) {
    $q = @{ startAt = $start; maxResults = $MaxResults; orderBy = $OrderBy }
    if ($Query) { $q.query = $Query }
    $page = $s.Projects.List($q)
    foreach ($p in $page.values) { [void]$acc.Add($p) }
    $start += $page.values.Count
    if ($page.values.Count -eq 0) { break }
    if ($page.isLast -eq $true) { break }
    if ($null -ne $page.total -and $start -ge $page.total) { break }
}
$acc | Write-Output
