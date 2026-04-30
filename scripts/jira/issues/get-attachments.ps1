#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.GetAttachmentsMeta($IssueKey) | Write-Output
