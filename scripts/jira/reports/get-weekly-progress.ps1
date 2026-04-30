#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$Days = 7,
    [int]$MaxIssues = 800
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND updated >= -${Days}d"
$issues = $s.Issues.Search($jql, @('status', 'updated'), 100, $MaxIssues)
$done = @($issues | Where-Object { $_.fields.status.statusCategory.key -eq 'done' })
$still = @($issues | Where-Object { $_.fields.status.statusCategory.key -ne 'done' })
[pscustomobject]@{
    ProjectKey       = $ProjectKey
    WindowDays       = $Days
    TouchedTotal     = $issues.Count
    TouchedDone      = $done.Count
    TouchedNotDone   = $still.Count
    DoneRatioInTouch = if ($issues.Count -gt 0) { [math]::Round($done.Count / $issues.Count, 4) } else { 0 }
} | Write-Output
