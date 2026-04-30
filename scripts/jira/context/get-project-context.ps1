#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 200
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$proj = $s.Projects.Get($ProjectKey, @{})
$openJql = "project = $ProjectKey AND resolution is EMPTY"
$open = @($s.Issues.Search($openJql, @('key'), 50, $MaxIssues))
[pscustomobject]@{
    ProjectKey = $ProjectKey
    Project    = $proj
    OpenCount  = $open.Count
    SampleKeys = ($open | Select-Object -First 15 | ForEach-Object { $_.key })
} | ConvertTo-Json -Depth 8
