#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [string]$Jql,
    [int]$MaxIssues = 300
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
. (Join-Path $PSScriptRoot 'JiraMemoryStore.ps1')
$s = New-JiraToolkitSession
$q = if ($Jql) { $Jql } else { "project = $ProjectKey ORDER BY updated DESC" }
$issues = $s.Issues.Search($q, @('summary', 'status', 'assignee', 'updated'), 50, $MaxIssues)
$store = [JiraMemoryStore]::new($PSScriptRoot)
$store.WriteIssues(@{ updatedAt = (Get-Date).ToString('o'); projectKey = $ProjectKey; issues = @($issues) })
Write-Host "Cached $($issues.Count) issues."
