#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 1000
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND resolution is EMPTY"
$issues = $s.Issues.Search($jql, @('summary', 'status', 'assignee', 'priority'), 100, $MaxIssues)
$issues | Group-Object { $_.fields.status.name } | ForEach-Object {
    [pscustomobject]@{ Status = $_.Name; Count = $_.Count; Issues = $_.Group }
} | Write-Output
