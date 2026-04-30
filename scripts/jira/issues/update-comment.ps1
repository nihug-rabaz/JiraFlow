#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$CommentId,
    [Parameter(Mandatory)][string]$BodyJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = $BodyJson | ConvertFrom-Json
$s.Issues.UpdateComment($IssueKey, $CommentId, $body) | Write-Output
