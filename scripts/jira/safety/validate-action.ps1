#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Intent,
    [string]$MapperPath,
    [string]$ConfirmToken,
    [switch]$Force
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
if (-not $MapperPath) {
    $MapperPath = Join-Path (Join-Path (Join-Path $PSScriptRoot '..') 'orchestrator') 'intent-mapper.json'
}
$m = Get-Content -LiteralPath $MapperPath -Raw -Encoding UTF8 | ConvertFrom-Json
$key = $Intent -replace '-', '_'
$names = @($m.intents.PSObject.Properties | ForEach-Object { $_.Name })
if ($names -notcontains $key) {
    throw "validate-action: unknown intent $Intent"
}
$def = $m.intents.$key
if ($def.requireConfirm -eq $true -and -not $Force) {
    if ($ConfirmToken -ne 'CONFIRM_DESTRUCTIVE' -and $env:JIRA_CONFIRM_DESTRUCTIVE -ne '1') {
        throw "validate-action: destructive intent $Intent blocked (set ConfirmToken or env JIRA_CONFIRM_DESTRUCTIVE=1 or -Force)."
    }
}
Write-Host "validate-action: OK for $Intent"
