#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Range = 'HEAD~1..HEAD',
    [string]$CommentBody
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$rp = (Resolve-Path $RepoPath).Path
$branch = (Invoke-JiraGitCommand -RepoPath $rp -GitArgs 'rev-parse --abbrev-ref HEAD').Trim()
$diff = Invoke-JiraGitCommand -RepoPath $rp -GitArgs "diff $Range"
$keys = Get-JiraKeysFromText -Text ("$branch`n$diff")
$msg = if ($CommentBody) { $CommentBody } else { "Git sync: branch $branch`n``````diff`n$($diff.Substring(0, [Math]::Min(8000, $diff.Length)))`n``````" }
foreach ($k in $keys) {
    $body = @{ body = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $msg }) }) } }
    $s.Issues.AddComment($k, $body) | Out-Null
    Write-Host "Commented on $k"
}
