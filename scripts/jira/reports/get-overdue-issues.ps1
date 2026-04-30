#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND duedate < startOfDay() AND resolution is EMPTY ORDER BY duedate ASC"
$s.Issues.Search($jql, @('summary', 'status', 'assignee', 'duedate'), 100, $MaxIssues) | Write-Output
