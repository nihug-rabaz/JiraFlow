class JiraAgileApi {
    hidden [JiraRestClient] $Http

    JiraAgileApi([JiraRestClient]$http) { $this.Http = $http }

    [object] ListBoards([hashtable]$query) { return $this.Http.GetAgile('board', $query) }

    [object] GetBoard([int]$boardId) { return $this.Http.GetAgile("board/$boardId", $null) }

    [object] GetBoardIssues([int]$boardId, [hashtable]$query) {
        return $this.Http.GetAgile("board/$boardId/issue", $query)
    }

    [object] ListSprints([int]$boardId, [hashtable]$query) {
        return $this.Http.GetAgile("board/$boardId/sprint", $query)
    }

    [object] GetSprint([int]$sprintId) { return $this.Http.GetAgile("sprint/$sprintId", $null) }

    [object] CreateSprint([object]$body) { return $this.Http.PostAgile('sprint', $body, $null) }

    [object] UpdateSprint([int]$sprintId, [object]$body) {
        return $this.Http.PutAgile("sprint/$sprintId", $body, $null)
    }

    [object] MoveIssuesToSprint([int]$sprintId, [object]$body) {
        return $this.Http.PostAgile("sprint/$sprintId/issue", $body, $null)
    }

    [object] MoveIssuesToBacklog([int]$boardId, [object]$body) {
        return $this.Http.PostAgile("backlog/$boardId/issue", $body, $null)
    }

    [object] RankIssues([object]$body) { return $this.Http.PutAgile('issue/rank', $body, $null) }
}
