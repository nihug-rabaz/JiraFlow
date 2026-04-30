#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [int]$MaxIssues = 200,
    [switch]$SkipLlm
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$jql = "project = $ProjectKey AND updated >= -7d ORDER BY updated DESC"
$issues = $s.Issues.Search($jql, @('summary', 'status', 'assignee', 'issuetype'), 50, $MaxIssues)
$lines = $issues | ForEach-Object { '{0} [{1}] {2} ({3})' -f $_.key, $_.fields.issuetype.name, $_.fields.summary, $_.fields.status.name }
$blob = $lines -join "`n"
if ($SkipLlm) {
    $blob | Write-Output
    return
}
$sys = 'You produce a concise weekly Jira progress summary: themes, risks, and next week focus. Plain text, under 20 lines.'
$out = $s.Llm.Complete($sys, $blob)
$out | Write-Output
