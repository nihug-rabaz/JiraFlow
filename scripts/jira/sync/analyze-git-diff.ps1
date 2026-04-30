#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Range = 'HEAD~1..HEAD',
    [switch]$Stat
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$gitArgs = if ($Stat) { "diff --stat $Range" } else { "diff $Range" }
Invoke-JiraGitCommand -RepoPath (Resolve-Path $RepoPath).Path -GitArgs $gitArgs | Write-Output
