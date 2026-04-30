#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string[]]$ProjectKeys,
    [int[]]$IssueTypeIds,
    [string[]]$Expand
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$q = @{ projectKeys = $ProjectKeys }
if ($IssueTypeIds -and $IssueTypeIds.Count -gt 0) { $q.issuetypeIds = $IssueTypeIds }
if ($Expand -and $Expand.Count -gt 0) { $q.expand = $Expand -join ',' }
$s.Meta.GetCreateMeta($q) | Write-Output
