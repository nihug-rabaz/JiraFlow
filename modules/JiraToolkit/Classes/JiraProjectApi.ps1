class JiraProjectApi {
    hidden [JiraRestClient] $Http

    JiraProjectApi([JiraRestClient]$http) { $this.Http = $http }

    [object] List([hashtable]$query) { return $this.Http.GetV3('project/search', $query) }

    [object] Get([string]$key, [hashtable]$query) { return $this.Http.GetV3("project/$key", $query) }

    [object] Create([object]$body) { return $this.Http.PostV3('project', $body, $null) }

    [object] Update([string]$key, [object]$body) {
        return $this.Http.PutV3("project/$key", $body, $null)
    }

    [void] Archive([string]$key) { [void]$this.Http.PostV3("project/$key/archive", @{}, $null) }

    [object] GetComponents([string]$projectKey) {
        return $this.Http.GetV3("project/$projectKey/components", $null)
    }

    [object] CreateComponent([object]$body) { return $this.Http.PostV3('component', $body, $null) }

    [object] UpdateComponent([string]$id, [object]$body) {
        return $this.Http.PutV3("component/$id", $body, $null)
    }

    [void] DeleteComponent([string]$id) { [void]$this.Http.DeleteV3("component/$id", $null) }

    [object] GetVersions([string]$projectKey) {
        return $this.Http.GetV3("project/$projectKey/versions", $null)
    }

    [object] CreateVersion([object]$body) { return $this.Http.PostV3('version', $body, $null) }

    [object] UpdateVersion([string]$id, [object]$body) {
        return $this.Http.PutV3("version/$id", $body, $null)
    }

    [object] ReleaseVersion([string]$id, [object]$body) {
        if (-not $body) { $body = @{ released = $true } }
        return $this.Http.PutV3("version/$id", $body, $null)
    }

    [object] SetProperty([string]$projectKey, [string]$propertyKey, [object]$value) {
        $body = @{ value = $value }
        return $this.Http.PutV3("project/$projectKey/properties/$propertyKey", $body, $null)
    }

    [object] GetProperty([string]$projectKey, [string]$propertyKey) {
        return $this.Http.GetV3("project/$projectKey/properties/$propertyKey", $null)
    }
}
