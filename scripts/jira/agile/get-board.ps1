#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$BoardId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Agile.GetBoard($BoardId) | Write-Output
