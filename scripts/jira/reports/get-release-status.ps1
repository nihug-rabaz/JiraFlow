#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][string]$VersionName,
    [int]$MaxIssues = 1000
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = 'project = {0} AND fixVersion = "{1}"' -f $ProjectKey, $VersionName.Replace('"', '\"')
$issues = $s.Issues.Search($jql, @('summary', 'status', 'issuetype'), 100, $MaxIssues)
$g = $issues | Group-Object { $_.fields.status.statusCategory.name }
[pscustomobject]@{
    ProjectKey = $ProjectKey
    Version    = $VersionName
    Total      = $issues.Count
    ByCategory = ($g | ForEach-Object { [pscustomobject]@{ Category = $_.Name; Count = $_.Count } })
    Issues     = $issues
} | Write-Output
