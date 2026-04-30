#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$Label
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$issue = $s.Issues.Get($IssueKey, @('labels'), $null)
$cur = @($issue.fields.labels) | Where-Object { $_ -ne $Label }
$body = @{ fields = @{ labels = @($cur) } }
$s.Issues.Update($IssueKey, $body) | Write-Output
