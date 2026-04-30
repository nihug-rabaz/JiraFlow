#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$EpicKey
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$fid = $s.Epic.ResolveEpicLinkFieldId()
$body = @{ fields = @{} }
$body.fields[$fid] = $EpicKey
$s.Issues.Update($IssueKey, $body) | Write-Output
