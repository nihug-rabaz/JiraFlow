#requires -Version 5.1
[CmdletBinding()]
param(
    [string[]]$Permissions,
    [string]$ProjectKey,
    [string]$IssueKey
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.GetPermissions($Permissions, $ProjectKey, $IssueKey) | Write-Output
