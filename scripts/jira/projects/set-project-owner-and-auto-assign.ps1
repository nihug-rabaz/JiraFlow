#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [string]$OwnerAccountId,
    [string]$OwnerEmail,
    [string]$OwnerQuery,
    [switch]$SetProjectLead,
    [switch]$SetDefaultAssigneeToLead,
    [switch]$AddToAdministratorsRole,
    [int]$RoleId,
    [switch]$ReassignAllOpenIssues,
    [string]$IssueJql
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession

$resolvedAccountId = $OwnerAccountId
if (-not $resolvedAccountId) {
    $q = if ($OwnerEmail) { $OwnerEmail } elseif ($OwnerQuery) { $OwnerQuery } else { throw 'Provide OwnerAccountId, OwnerEmail, or OwnerQuery.' }
    $users = @($s.Users.Search($q, 20))
    if ($users.Count -eq 0) { throw "No Jira user found for '$q'." }
    if ($OwnerEmail) {
        $exact = @($users | Where-Object { $_.emailAddress -eq $OwnerEmail })
        if ($exact.Count -gt 0) { $resolvedAccountId = $exact[0].accountId }
    }
    if (-not $resolvedAccountId) { $resolvedAccountId = $users[0].accountId }
}

if ($SetProjectLead -or $SetDefaultAssigneeToLead) {
    $body = @{}
    if ($SetProjectLead) { $body.leadAccountId = $resolvedAccountId }
    if ($SetDefaultAssigneeToLead) { $body.assigneeType = 'PROJECT_LEAD' }
    if ($body.Count -gt 0) { $null = $s.Projects.Update($ProjectKey, $body) }
}

$resolvedRoleId = $RoleId
if ($AddToAdministratorsRole) {
    if (-not $resolvedRoleId) {
        $roles = $s.Users.GetProjectRoles($ProjectKey)
        foreach ($prop in $roles.PSObject.Properties) {
            if ($prop.Name -match 'admin') {
                $m = [regex]::Match("$($prop.Value)", '/(\d+)$')
                if ($m.Success) {
                    $resolvedRoleId = [int]$m.Groups[1].Value
                    break
                }
            }
        }
        if (-not $resolvedRoleId) { throw "Could not resolve Administrators role id for project '$ProjectKey'." }
    }
    $null = $s.Users.AddActor($ProjectKey, $resolvedRoleId, $resolvedAccountId)
}

$assigned = 0
$assignFailed = 0
$jql = if ($IssueJql) {
    $IssueJql
}
elseif ($ReassignAllOpenIssues) {
    "project = $ProjectKey AND statusCategory != Done"
}
else {
    "project = $ProjectKey AND assignee IS EMPTY AND statusCategory != Done"
}

$issues = @($s.Issues.Search($jql, @('key'), 100, 5000))
foreach ($issue in $issues) {
    try {
        $null = $s.Issues.Assign($issue.key, $resolvedAccountId)
        $assigned++
    }
    catch {
        $assignFailed++
    }
}

[pscustomobject]@{
    ProjectKey             = $ProjectKey
    OwnerAccountId         = $resolvedAccountId
    SetProjectLead         = [bool]$SetProjectLead
    SetDefaultAssigneeLead = [bool]$SetDefaultAssigneeToLead
    AddedToRoleId          = $resolvedRoleId
    AssignmentJql          = $jql
    AssignedIssues         = $assigned
    FailedAssignments      = $assignFailed
} | Write-Output
