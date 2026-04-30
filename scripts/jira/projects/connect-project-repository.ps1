#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][string]$RepositoryUrl,
    [ValidateSet('github', 'bitbucket', 'gitlab', 'other')][string]$RepositoryType = 'github',
    [string]$RepositoryName,
    [string]$Provider,
    [string]$PropertyKey = 'cursor.repo.config',
    [switch]$LinkExistingIssues,
    [string]$LinkJql
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession

$repoConfig = @{
    url        = $RepositoryUrl
    type       = $RepositoryType
    name       = $RepositoryName
    provider   = $Provider
    updatedAt  = (Get-Date).ToString('o')
}
$null = $s.Projects.SetProperty($ProjectKey, $PropertyKey, $repoConfig)

$linked = 0
$failed = 0
if ($LinkExistingIssues) {
    $jql = if ($LinkJql) { $LinkJql } else { "project = $ProjectKey" }
    $issues = @($s.Issues.Search($jql, @('key'), 100, 5000))
    foreach ($issue in $issues) {
        try {
            $body = @{
                globalId = "cursor:$ProjectKey:$RepositoryUrl"
                object   = @{
                    url   = $RepositoryUrl
                    title = if ($RepositoryName) { $RepositoryName } else { $RepositoryUrl }
                    icon  = @{ title = $RepositoryType }
                }
            }
            $null = $s.Issues.CreateRemoteIssueLink($issue.key, $body)
            $linked++
        }
        catch {
            $failed++
        }
    }
}

[pscustomobject]@{
    ProjectKey         = $ProjectKey
    RepositoryUrl      = $RepositoryUrl
    RepositoryType     = $RepositoryType
    PropertyKey        = $PropertyKey
    LinkExistingIssues = [bool]$LinkExistingIssues
    LinkedIssues       = $linked
    FailedLinks        = $failed
} | Write-Output
