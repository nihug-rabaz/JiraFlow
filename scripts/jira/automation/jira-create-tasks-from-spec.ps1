#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][string]$SpecPath,
    [Parameter(Mandatory)][string]$IssueTypeName,
    [switch]$WhatIf
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$text = Get-Content -LiteralPath $SpecPath -Raw -ErrorAction Stop
$sys = 'You convert a product spec into a JSON array only (no markdown): [{"summary":"...","description":"..."}, ...]. Max 25 items, actionable dev tasks.'
$user = "Spec file:`n$text"
$raw = $s.Llm.Complete($sys, $user)
$raw = $raw.Trim()
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
