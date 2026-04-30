#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [string]$Jql,
    [int]$MaxIssues = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
if (-not $Jql) {
    $Jql = "project = $ProjectKey AND resolution is EMPTY AND labels = blocked"
}
$s.Issues.Search($Jql, @('summary', 'status', 'assignee', 'labels'), 100, $MaxIssues) | Write-Output
