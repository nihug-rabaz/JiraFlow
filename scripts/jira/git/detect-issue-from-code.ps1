#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Branch,
    [string]$ExtraText,
    [string]$Range = 'HEAD~1..HEAD'
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$rp = (Resolve-Path $RepoPath).Path
$parts = [System.Collections.ArrayList]::new()
if ($Branch) { [void]$parts.Add($Branch) }
else {
    [void]$parts.Add((Invoke-JiraGitCommand -RepoPath $rp -GitArgs 'rev-parse --abbrev-ref HEAD').Trim())
}
if ($ExtraText) { [void]$parts.Add($ExtraText) }
[void]$parts.Add((Invoke-JiraGitCommand -RepoPath $rp -GitArgs "diff $Range"))
$blob = $parts -join "`n"
Get-JiraKeysFromText -Text $blob | Select-Object -Unique | Write-Output
