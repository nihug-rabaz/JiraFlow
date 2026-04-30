#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$AccountId,
    [string]$ProjectKey,
    [int]$MaxIssues = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "assignee = `"$AccountId`" AND resolution is EMPTY"
if ($ProjectKey) { $jql = "project = $ProjectKey AND $jql" }
$issues = $s.Issues.Search($jql, @('summary', 'status', 'priority', 'issuetype'), 100, $MaxIssues)
$g = $issues | Group-Object { $_.fields.status.name }
[pscustomobject]@{
    AccountId = $AccountId
    OpenTotal = $issues.Count
    ByStatus  = ($g | ForEach-Object { [pscustomobject]@{ Status = $_.Name; Count = $_.Count } })
    Issues    = $issues
} | Write-Output
