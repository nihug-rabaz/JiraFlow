#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 400,
    [switch]$WhatIf
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND resolution is EMPTY ORDER BY created ASC"
$issues = $s.Issues.Search($jql, @('summary', 'description', 'created'), 50, $MaxIssues)
$norm = {
    param($t)
    if (-not $t) { return '' }
    ($t -replace '\s+', ' ').Trim().ToLowerInvariant()
}
$groups = $issues | Group-Object { & $norm $_.fields.summary }
foreach ($g in $groups) {
    if ($g.Count -lt 2) { continue }
    $sorted = @($g.Group | Sort-Object { $_.fields.created })
    if ($sorted.Count -lt 2) { continue }
    $keep = $sorted[0]
    $dupes = $sorted[1..($sorted.Count - 1)]
    [pscustomobject]@{
        SummaryNorm = $g.Name
        Keep        = $keep.key
        Duplicates  = @($dupes | ForEach-Object { $_.key })
        WhatIf      = $WhatIf.IsPresent
    } | Write-Output
    if (-not $WhatIf) {
        foreach ($d in $dupes) {
            $body = @{ fields = @{ labels = @('possible-duplicate') } }
            try {
                $issue = $s.Issues.Get($d.key, @('labels'), $null)
                $cur = @($issue.fields.labels) + 'possible-duplicate' | Select-Object -Unique
                $body.fields.labels = $cur
                $s.Issues.Update($d.key, $body) | Out-Null
            }
            catch { Write-Warning $_ }
        }
    }
}
