#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$me = $s.Users.Myself()
$aid = $AccountId
if (-not $aid) { $aid = $me.accountId }
$user = $s.Users.Get($aid)
$jql = "assignee = `"$aid`" AND resolution is EMPTY"
$mine = @($s.Issues.Search($jql, @('key', 'summary', 'status'), 50, 100))
[pscustomobject]@{
    User       = $user
    OpenIssues = $mine.Count
    Issues     = $mine
} | ConvertTo-Json -Depth 8
