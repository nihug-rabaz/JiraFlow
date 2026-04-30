#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Message,
    [string]$RepoPath = '.',
    [string]$Commit = 'HEAD'
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$m = $Message
if (-not $m) {
    $rp = (Resolve-Path $RepoPath).Path
    $m = (Invoke-JiraGitCommand -RepoPath $rp -GitArgs "log -1 --pretty=%B $Commit").Trim()
}
Get-JiraKeysFromText -Text $m | Write-Output
