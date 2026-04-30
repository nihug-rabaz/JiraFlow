#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Jql,
    [string[]]$Fields = @('summary', 'status', 'assignee', 'issuetype', 'priority', 'updated'),
    [int]$PageSize = 50,
    [int]$MaxTotal = 0
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.Search($Jql, $Fields, $PageSize, $MaxTotal) | Write-Output
