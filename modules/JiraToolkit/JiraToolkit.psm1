# Requires: JIRA_BASE_URL (site root), JIRA_EMAIL, JIRA_API_TOKEN. Optional: JIRA_EPIC_LINK_FIELD, OPENAI_API_KEY.
if (-not ('System.Net.Http.HttpClient' -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}
$script:ClassFiles = @(
    'JiraConnectionConfig.ps1'
    'JiraRestClient.ps1'
    'JiraIssueApi.ps1'
    'JiraProjectApi.ps1'
    'JiraUserApi.ps1'
    'JiraAgileApi.ps1'
    'JiraMetaApi.ps1'
    'JiraWorkflowApi.ps1'
    'JiraGitIntegration.ps1'
    'JiraPayloadValidator.ps1'
    'JiraEpicHelper.ps1'
    'JiraLlmClient.ps1'
)
foreach ($f in $script:ClassFiles) {
    . (Join-Path $PSScriptRoot "Classes\$f")
}

function New-JiraToolkitSession {
    [CmdletBinding()]
    param()
    $cfg = [JiraConnectionConfig]::new()
    $client = [JiraRestClient]::new($cfg)
    $meta = [JiraMetaApi]::new($client)
    $issues = [JiraIssueApi]::new($client)
    $users = [JiraUserApi]::new($client)
    [pscustomobject]@{
        PSTypeName = 'JiraToolkitSession'
        Config     = $cfg
        Client     = $client
        Issues     = $issues
        Projects   = [JiraProjectApi]::new($client)
        Users      = $users
        Agile      = [JiraAgileApi]::new($client)
        Meta       = $meta
        Workflow   = [JiraWorkflowApi]::new($client)
        Epic       = [JiraEpicHelper]::new($meta, $cfg)
        Git        = [JiraGitIntegration]::new($issues, $users)
        Llm        = [JiraLlmClient]::new()
    }
}

function Invoke-JiraGitCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][string]$GitArgs
    )
    return [JiraGitIntegration]::RunGit($RepoPath, $GitArgs)
}

function Get-JiraKeysFromText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text
    )
    return [JiraGitIntegration]::ExtractIssueKeys($Text)
}

function Invoke-JiraValidateCreatePayload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$CreateMeta,
        [Parameter(Mandatory)][string]$ProjectKey,
        [Parameter(Mandatory)][string]$IssueTypeName,
        [Parameter(Mandatory)][object]$Fields
    )
    [JiraPayloadValidator]::ValidateCreatePayload($CreateMeta, $ProjectKey, $IssueTypeName, $Fields)
}

Export-ModuleMember -Function New-JiraToolkitSession, Invoke-JiraGitCommand, Get-JiraKeysFromText, Invoke-JiraValidateCreatePayload
