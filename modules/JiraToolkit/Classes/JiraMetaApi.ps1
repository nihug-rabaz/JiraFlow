class JiraMetaApi {
    hidden [JiraRestClient] $Http

    JiraMetaApi([JiraRestClient]$http) { $this.Http = $http }

    [object] ListIssueTypes([hashtable]$query) { return $this.Http.GetV3('issuetype', $query) }

    [object] ListFields() { return $this.Http.GetV3('field', $null) }

    [object] GetCreateMeta([hashtable]$query) {
        return $this.Http.GetV3('issue/createmeta', $query)
    }

    [object] GetEditMeta([string]$issueKey) {
        return $this.Http.GetV3("issue/$issueKey/editmeta", $null)
    }

    [object] ListPriorities() { return $this.Http.GetV3('priority', $null) }
}
