#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RequestPath,
    [string]$RequestJson,
    [switch]$DryRun,
    [switch]$Force
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
. (Join-Path $PSScriptRoot 'OrchestratorLib.ps1')
$mapperPath = Join-Path $PSScriptRoot 'intent-mapper.json'
$mapper = Get-Content -LiteralPath $mapperPath -Raw -Encoding UTF8 | ConvertFrom-Json
$aliases = @{
    sync_code            = 'sync_git_change_to_jira'
    analyze_project      = 'get_project_summary'
    create_task          = 'create_issue'
    update_task          = 'update_issue'
    list_open_by_status  = 'get_open_issues_by_status'
    project_health       = 'get_weekly_progress'
}
$text = $RequestJson
if ($RequestPath) { $text = Get-Content -LiteralPath $RequestPath -Raw -Encoding UTF8 }
if (-not $text) {
    $text = [Console]::In.ReadToEnd()
}
if (-not $text) { throw 'Provide -RequestJson, -RequestPath, or pipe JSON to stdin.' }
$req = [JiraOrchestrationEngine]::ReadRequest($text)
[JiraOrchestrationEngine]::Run($mapper, $req, $JiraToolkitRepoRoot, $aliases, $DryRun, $Force)
