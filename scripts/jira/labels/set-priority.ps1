#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$PriorityName
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{ fields = @{ priority = @{ name = $PriorityName } } }
$s.Issues.Update($IssueKey, $body) | Write-Output
