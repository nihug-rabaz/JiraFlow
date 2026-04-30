#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Query,
    [int]$MaxResults = 50
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Users.Search($Query, $MaxResults) | Write-Output
