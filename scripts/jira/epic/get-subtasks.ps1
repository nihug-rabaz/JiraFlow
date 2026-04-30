#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ParentKey,
    [string[]]$Fields = @('summary', 'status', 'assignee'),
    [int]$PageSize = 50,
    [int]$MaxTotal = 200
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "parent = $ParentKey"
$s.Issues.Search($jql, $Fields, $PageSize, $MaxTotal) | Write-Output
