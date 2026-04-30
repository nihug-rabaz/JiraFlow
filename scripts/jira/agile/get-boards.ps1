#requires -Version 5.1
[CmdletBinding()]
param(
    [int]$StartAt = 0,
    [int]$MaxResults = 50,
    [string]$Type,
    [string]$ProjectKeyOrId,
    [string]$Name
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{ startAt = $StartAt; maxResults = $MaxResults }
if ($Type) { $q.type = $Type }
if ($ProjectKeyOrId) { $q.projectKeyOrId = $ProjectKeyOrId }
if ($Name) { $q.name = $Name }
$s.Agile.ListBoards($q) | Write-Output
