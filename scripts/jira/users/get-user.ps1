#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$AccountId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.Get($AccountId) | Write-Output
