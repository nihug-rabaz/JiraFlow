#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.Assign($IssueKey, $AccountId) | Write-Output
