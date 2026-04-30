#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$aid = $AccountId
if (-not $aid) { $aid = $s.Users.Myself().accountId }
$s.Issues.Unwatch($IssueKey, $aid)
Write-Host "Stopped watching $IssueKey"
