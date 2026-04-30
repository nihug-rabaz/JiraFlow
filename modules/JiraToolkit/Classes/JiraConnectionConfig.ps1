class JiraConnectionConfig {
    [string] $BaseHost
    [string] $Email
    [string] $ApiToken
    [string] $EpicLinkFieldId

    JiraConnectionConfig() {
        $this.LoadFromEnvironment()
    }

    hidden [void] LoadFromEnvironment() {
        $raw = $env:JIRA_BASE_URL
        if (-not $raw) { throw "JIRA_BASE_URL is required (e.g. https://your-site.atlassian.net)" }
        $u = $raw.TrimEnd('/')
        if ($u -match '/rest/') { throw "JIRA_BASE_URL must be site root only, not /rest/..." }
        $this.BaseHost = $u
        $this.Email = $env:JIRA_EMAIL
        if (-not $this.Email) { throw "JIRA_EMAIL is required" }
        $this.ApiToken = $env:JIRA_API_TOKEN
        if (-not $this.ApiToken) { throw "JIRA_API_TOKEN is required" }
        $this.EpicLinkFieldId = $env:JIRA_EPIC_LINK_FIELD
    }

    [string] ApiV3Root() { return "$($this.BaseHost)/rest/api/3" }
    [string] AgileRoot() { return "$($this.BaseHost)/rest/agile/1.0" }

    [hashtable] AuthHeaders() {
        $pair = "{0}:{1}" -f $this.Email, $this.ApiToken
        $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($pair))
        return @{
            Authorization = "Basic $b64"
            Accept        = "application/json"
        }
    }
}
