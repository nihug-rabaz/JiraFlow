#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ComponentId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Projects.DeleteComponent($ComponentId)
Write-Host "Deleted component $ComponentId"
