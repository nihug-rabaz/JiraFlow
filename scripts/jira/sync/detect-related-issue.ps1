#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Branch,
    [string]$ExtraText
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$rp = (Resolve-Path $RepoPath).Path
$text = ''
if (-not $Branch) {
    $Branch = (Invoke-JiraGitCommand -RepoPath $rp -GitArgs 'rev-parse --abbrev-ref HEAD').Trim()
}
$text += $Branch + "`n"
if ($ExtraText) { $text += $ExtraText }
$diff = Invoke-JiraGitCommand -RepoPath $rp -GitArgs 'diff HEAD~1..HEAD'
$text += "`n" + $diff
Get-JiraKeysFromText -Text $text | Write-Output
