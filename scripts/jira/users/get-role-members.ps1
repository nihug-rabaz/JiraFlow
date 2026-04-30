#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][int]$RoleId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.GetRoleActors($ProjectKey, $RoleId) | Write-Output
