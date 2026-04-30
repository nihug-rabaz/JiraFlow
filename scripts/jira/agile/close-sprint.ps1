#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$SprintId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = @{ state = 'closed' }
$s.Agile.UpdateSprint($SprintId, $body) | Write-Output
