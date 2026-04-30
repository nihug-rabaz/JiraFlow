#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 60,
    [switch]$SkipLlm
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND resolution is EMPTY ORDER BY updated ASC"
$issues = $s.Issues.Search($jql, @('summary', 'status', 'priority', 'assignee'), 50, $MaxIssues)
$lines = $issues | ForEach-Object { '{0} {1} [{2}]' -f $_.key, $_.fields.summary, $_.fields.status.name }
$blob = $lines -join "`n"
if ($SkipLlm) {
    $blob | Write-Output
    return
}
$sys = 'From this open Jira backlog, suggest 5-10 concrete next actions for the team. Numbered list, plain text.'
$out = $s.Llm.Complete($sys, $blob)
$out | Write-Output
