#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$OtherIssueKey,
    [string]$LinkTypeName
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.DeleteIssueLinkBetween($IssueKey, $OtherIssueKey, $LinkTypeName)
Write-Host "Removed link between $IssueKey and $OtherIssueKey"
