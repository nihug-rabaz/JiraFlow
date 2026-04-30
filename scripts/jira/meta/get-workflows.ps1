#requires -Version 5.1
[CmdletBinding()]
param(
    [int]$StartAt = 0,
    [int]$MaxResults = 50,
    [string]$QueryString,
    [string]$Expand
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{ startAt = $StartAt; maxResults = $MaxResults }
if ($QueryString) { $q.queryString = $QueryString }
if ($Expand) { $q.expand = $Expand }
try {
    $s.Workflow.ListWorkflows($q) | Write-Output
}
catch {
    Write-Warning $_.Exception.Message
    throw
}
