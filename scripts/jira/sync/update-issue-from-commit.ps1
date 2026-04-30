#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoPath = '.',
    [string]$Commit = 'HEAD',
    [string]$CommentTemplate
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$rp = (Resolve-Path $RepoPath).Path
$msg = (Invoke-JiraGitCommand -RepoPath $rp -GitArgs "log -1 --pretty=%B $Commit").Trim()
$keys = Get-JiraKeysFromText -Text $msg
foreach ($k in $keys) {
    $line = if ($CommentTemplate) { $CommentTemplate -f $msg } else { "Commit: $msg" }
    $body = @{ body = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $line }) }) } }
    $s.Issues.AddComment($k, $body) | Out-Null
    Write-Host "Updated $k from commit message"
}
