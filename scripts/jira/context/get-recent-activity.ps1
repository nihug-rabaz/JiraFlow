#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$Days = 7,
    [int]$MaxIssues = 100
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND updated >= -${Days}d ORDER BY updated DESC"
$issues = $s.Issues.Search($jql, @('summary', 'status', 'assignee', 'updated'), 50, $MaxIssues)
[pscustomobject]@{
    ProjectKey = $ProjectKey
    Days       = $Days
    Count      = $issues.Count
    Issues     = $issues
} | ConvertTo-Json -Depth 8
