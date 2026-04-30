#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 1000
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey"
$issues = $s.Issues.Search($jql, @('status'), 100, $MaxIssues)
$g = $issues | Group-Object { $_.fields.status.name }
[pscustomobject]@{
    ProjectKey = $ProjectKey
    Total      = $issues.Count
    ByStatus   = ($g | ForEach-Object { [pscustomobject]@{ Status = $_.Name; Count = $_.Count } })
} | Write-Output
