#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$Label
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$issue = $s.Issues.Get($IssueKey, @('labels'), $null)
$cur = @($issue.fields.labels)
if ($cur -contains $Label) { Write-Host "Label already present"; return }
$all = @($cur + $Label)
$body = @{ fields = @{ labels = $all } }
$s.Issues.Update($IssueKey, $body) | Write-Output
