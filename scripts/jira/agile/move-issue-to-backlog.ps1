#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$BoardId,
    [Parameter(Mandatory)][string[]]$IssueKeys
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{ issues = @($IssueKeys) }
$s.Agile.MoveIssuesToBacklog($BoardId, $body) | Write-Output
