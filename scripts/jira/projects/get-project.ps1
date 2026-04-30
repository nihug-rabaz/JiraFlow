#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [string[]]$Expand
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{}
if ($Expand -and $Expand.Count -gt 0) { $q.expand = $Expand -join ',' }
$s.Projects.Get($ProjectKey, $q) | Write-Output
