#requires -Version 5.1
[CmdletBinding()]
param()
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.Myself() | Write-Output
Write-Host 'Jira connection OK'
