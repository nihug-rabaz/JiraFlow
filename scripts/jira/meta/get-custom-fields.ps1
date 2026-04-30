#requires -Version 5.1
[CmdletBinding()]
param()
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
@($s.Meta.ListFields() | Where-Object { $_.custom -eq $true }) | Write-Output
