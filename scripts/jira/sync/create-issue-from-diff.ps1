#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][string]$IssueTypeName,
    [string]$RepoPath = '.',
    [string]$Range = 'HEAD~1..HEAD'
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$rp = (Resolve-Path $RepoPath).Path
$diff = Invoke-JiraGitCommand -RepoPath $rp -GitArgs "diff $Range"
$lines = @($diff -split "`n")
$head = if ($lines.Count -gt 0) { ($lines[0..([Math]::Min(4, $lines.Count - 1))] -join ' ') } else { 'empty' }
if ($head.Length -eq 0) { $head = 'empty' }
$summary = 'Change: ' + $head.Substring(0, [Math]::Min(120, $head.Length))
$desc = $diff.Substring(0, [Math]::Min(32000, $diff.Length))
$body = @{
    fields = @{
        project   = @{ key = $ProjectKey }
        summary   = $summary
        issuetype = @{ name = $IssueTypeName }
        description = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $desc }) }) }
    }
}
$s.Issues.Create($body) | Write-Output
