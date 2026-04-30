#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 500
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND labels is not EMPTY"
$issues = $s.Issues.Search($jql, @('labels'), 100, $MaxIssues)
$set = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($i in $issues) {
    foreach ($lb in @($i.fields.labels)) { [void]$set.Add($lb) }
}
$set | Sort-Object | Write-Output
