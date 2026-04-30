#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$Days = 7,
    [int]$MaxIssues = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND updated >= -${Days}d ORDER BY updated DESC"
$s.Issues.Search($jql, @('summary', 'status', 'assignee', 'updated'), 100, $MaxIssues) | Write-Output
