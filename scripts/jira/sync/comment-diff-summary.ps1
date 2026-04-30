#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [string]$RepoPath = '.',
    [string]$Range = 'HEAD~1..HEAD',
    [int]$MaxChars = 12000
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$rp = (Resolve-Path $RepoPath).Path
$diff = Invoke-JiraGitCommand -RepoPath $rp -GitArgs "diff $Range"
$chunk = $diff.Substring(0, [Math]::Min($MaxChars, $diff.Length))
$text = "Diff summary ($Range):`n``````diff`n$chunk`n``````"
$body = @{ body = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $text }) }) } }
$s.Issues.AddComment($IssueKey, $body) | Write-Output
