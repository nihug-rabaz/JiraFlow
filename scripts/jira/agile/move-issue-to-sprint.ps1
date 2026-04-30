#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$SprintId,
    [Parameter(Mandatory)][string[]]$IssueKeys
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{ issues = @($IssueKeys) }
$s.Agile.MoveIssuesToSprint($SprintId, $body) | Write-Output
