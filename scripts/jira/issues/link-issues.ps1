#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$LinkTypeName,
    [Parameter(Mandatory)][string]$InwardIssueKey,
    [Parameter(Mandatory)][string]$OutwardIssueKey
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{
    type         = @{ name = $LinkTypeName }
    inwardIssue  = @{ key = $InwardIssueKey }
    outwardIssue = @{ key = $OutwardIssueKey }
}
$s.Issues.CreateIssueLink($body) | Write-Output
