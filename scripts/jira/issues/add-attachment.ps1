#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(Mandatory)][string]$FilePath
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$p = Resolve-Path -LiteralPath $FilePath
$s.Issues.AddAttachment($IssueKey, $p.Path) | Write-Output
