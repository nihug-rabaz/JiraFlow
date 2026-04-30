#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][int]$RoleId,
    [Parameter(Mandatory)][string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.AddActor($ProjectKey, $RoleId, $AccountId) | Write-Output
