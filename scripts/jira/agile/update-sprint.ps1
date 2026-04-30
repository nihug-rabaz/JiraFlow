#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$SprintId,
    [Parameter(Mandatory)][string]$BodyJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = $BodyJson | ConvertFrom-Json
$s.Agile.UpdateSprint($SprintId, $body) | Write-Output
