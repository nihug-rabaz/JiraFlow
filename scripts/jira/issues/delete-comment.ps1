#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$CommentId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.DeleteComment($IssueKey, $CommentId)
Write-Host "Deleted comment $CommentId"
