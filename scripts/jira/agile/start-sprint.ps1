#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$SprintId,
    [string]$StartDate,
    [string]$EndDate
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{ state = 'active' }
if ($StartDate) { $body.startDate = $StartDate }
if ($EndDate) { $body.endDate = $EndDate }
$s.Agile.UpdateSprint($SprintId, $body) | Write-Output
