#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [string]$CodeRoot = '.',
    [string]$Glob = '*.{cs,ts,tsx,js,py,ps1}',
    [int]$MaxFiles = 40,
    [int]$MaxCharsPerFile = 4000,
    [Parameter(Mandatory)][string]$IssueTypeName,
    [switch]$WhatIf
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$root = (Resolve-Path $CodeRoot).Path
$inc = $Glob -split ',' | ForEach-Object { $_.Trim() }
$take = Get-ChildItem -Path (Join-Path $root '*') -Recurse -File -Include $inc -ErrorAction SilentlyContinue | Select-Object -First $MaxFiles
$chunks = [System.Text.StringBuilder]::new()
foreach ($f in $take) {
    $txt = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $txt) { continue }
    if ($txt.Length -gt $MaxCharsPerFile) { $txt = $txt.Substring(0, $MaxCharsPerFile) }
    [void]$chunks.AppendLine("FILE: $($f.FullName)")
    [void]$chunks.AppendLine($txt)
    [void]$chunks.AppendLine()
}
$blob = $chunks.ToString()
$sys = 'From this codebase sample, propose a JSON array only: [{"summary":"...","description":"..."}] of up to 15 Jira engineering tasks (tests, refactors, docs). No markdown.'
$user = $blob
$raw = $s.Llm.Complete($sys, $user).Trim()
if ($raw.StartsWith('```')) {
    $raw = ($raw -replace '^```\w*', '' -replace '```$', '').Trim()
}
$arr = $raw | ConvertFrom-Json
foreach ($item in @($arr)) {
    if ($WhatIf) {
        [pscustomobject]@{ summary = $item.summary } | Write-Output
        continue
    }
    $body = @{
        fields = @{
            project   = @{ key = $ProjectKey }
            summary   = [string]$item.summary
            issuetype = @{ name = $IssueTypeName }
        }
    }
    if ($item.description) {
        $body.fields.description = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = [string]$item.description }) }) }
    }
    $s.Issues.Create($body) | Write-Output
}
