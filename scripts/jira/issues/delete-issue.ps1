#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [switch]$DeleteSubtasks
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.Delete($IssueKey, $DeleteSubtasks.IsPresent)
Write-Host "Deleted $IssueKey"
