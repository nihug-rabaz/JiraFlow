#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$BoardId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$r = $s.Agile.ListSprints($BoardId, @{ state = 'active'; maxResults = 10 })
@($r.values) | Write-Output
