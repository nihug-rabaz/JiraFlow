#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$EpicKey,
    [string[]]$Fields = @('summary', 'status', 'issuetype', 'assignee'),
    [int]$PageSize = 50,
    [int]$MaxTotal = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = ('"Epic Link" = {0}' -f $EpicKey)
$s.Issues.Search($jql, $Fields, $PageSize, $MaxTotal) | Write-Output
