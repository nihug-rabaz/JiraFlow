#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Branch,
    [string]$RepoPath = '.'
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$b = $Branch
if (-not $b) {
    $rp = (Resolve-Path $RepoPath).Path
    $b = (Invoke-JiraGitCommand -RepoPath $rp -GitArgs 'rev-parse --abbrev-ref HEAD').Trim()
}
$keys = Get-JiraKeysFromText -Text $b
if ($keys.Count -eq 0) { return }
$keys[0] | Write-Output
