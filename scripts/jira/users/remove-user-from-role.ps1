#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][int]$RoleId,
    [Parameter(Mandatory)][string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.RemoveActor($ProjectKey, $RoleId, $AccountId)
Write-Host "Removed $AccountId from role $RoleId"
