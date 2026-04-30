#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$BoardId,
    [int]$StartAt = 0,
    [int]$MaxResults = 50,
    [string]$State
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{ startAt = $StartAt; maxResults = $MaxResults }
if ($State) { $q.state = $State }
$s.Agile.ListSprints($BoardId, $q) | Write-Output
