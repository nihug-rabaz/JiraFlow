#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$BoardId,
    [int]$StartAt = 0,
    [int]$MaxResults = 50,
    [string]$Jql
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{ startAt = $StartAt; maxResults = $MaxResults }
if ($Jql) { $q.jql = $Jql }
$s.Agile.GetBoardIssues($BoardId, $q) | Write-Output
