class JiraWorkflowApi {
    hidden [JiraRestClient] $Http

    JiraWorkflowApi([JiraRestClient]$http) { $this.Http = $http }

    [object] ListWorkflows([hashtable]$query) {
        return $this.Http.GetV3('workflow/search', $query)
    }

    [object] ListStatuses() { return $this.Http.GetV3('status', $null) }

    [object] ListStatusCategories() { return $this.Http.GetV3('statuscategory', $null) }
}
