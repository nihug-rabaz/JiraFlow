#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$VersionId,
    [string]$BodyJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$body = $null
if ($BodyJson) { $body = $BodyJson | ConvertFrom-Json }
$s.Projects.ReleaseVersion($VersionId, $body) | Write-Output
