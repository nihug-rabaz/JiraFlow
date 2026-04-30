#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 80,
    [switch]$SkipLlm
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND updated >= -1d ORDER BY updated DESC"
$issues = $s.Issues.Search($jql, @('summary', 'status', 'assignee'), 50, $MaxIssues)
$lines = $issues | ForEach-Object { '{0} {1} ({2})' -f $_.key, $_.fields.summary, $_.fields.status.name }
$blob = $lines -join "`n"
if ($SkipLlm) {
    $blob | Write-Output
    return
}
$sys = 'You summarize Jira activity for stakeholders in 5-8 bullet points, plain text.'
$out = $s.Llm.Complete($sys, $blob)
$out | Write-Output
