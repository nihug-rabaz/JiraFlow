class JiraUserApi {
    hidden [JiraRestClient] $Http

    JiraUserApi([JiraRestClient]$http) { $this.Http = $http }

    [object] Myself() { return $this.Http.GetV3('myself', $null) }

    [object] Search([string]$query, [int]$maxResults) {
        $q = @{ query = $query }
        if ($maxResults -gt 0) { $q.maxResults = $maxResults }
        return $this.Http.GetV3('user/search', $q)
    }

    [object] Get([string]$accountId) {
        return $this.Http.GetV3('user', @{ accountId = $accountId })
    }

    [object] GetPermissions([string[]]$permissions, [string]$projectKey, [string]$issueKey) {
        $q = @{}
        if ($permissions -and $permissions.Count -gt 0) {
            $q.permissions = $permissions -join ','
        }
        if ($projectKey) { $q.projectKey = $projectKey }
        if ($issueKey) { $q.issueKey = $issueKey }
        return $this.Http.GetV3('mypermissions', $q)
    }

    [object] GetProjectRoles([string]$projectKey) {
        return $this.Http.GetV3("project/$projectKey/role", $null)
    }

    [object] GetRoleActors([string]$projectKey, [int]$roleId) {
        return $this.Http.GetV3("project/$projectKey/role/$roleId", $null)
    }

    [object] AddActor([string]$projectKey, [int]$roleId, [string]$accountId) {
        $body = @{ user = @($accountId) }
        return $this.Http.PostV3("project/$projectKey/role/$roleId", $body, $null)
    }

    [void] RemoveActor([string]$projectKey, [int]$roleId, [string]$accountId) {
        [void]$this.Http.DeleteV3("project/$projectKey/role/$roleId", @{ accountId = $accountId })
    }
}
