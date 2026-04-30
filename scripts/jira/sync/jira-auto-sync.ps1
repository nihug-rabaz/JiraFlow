#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Range = 'HEAD~1..HEAD'
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
& (Join-Path $PSScriptRoot 'sync-git-change-to-jira.ps1') -RepoPath $RepoPath -Range $Range
