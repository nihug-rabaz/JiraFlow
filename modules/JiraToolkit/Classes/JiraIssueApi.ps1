class JiraIssueApi {
    hidden [JiraRestClient] $Http

    JiraIssueApi([JiraRestClient]$http) { $this.Http = $http }

    [object] Search([string]$jql, [string[]]$fields, [int]$page, [int]$maxTotal) {
        return $this.Http.SearchJql($jql, $fields, $page, $maxTotal)
    }

    [object] Get([string]$issueKey, [string[]]$fields, [string]$expand) {
        $q = @{}
        if ($fields -and $fields.Count -gt 0) { $q.fields = $fields -join ',' }
        if ($expand) { $q.expand = $expand }
        return $this.Http.GetV3("issue/$issueKey", $q)
    }

    [object] Create([object]$body) { return $this.Http.PostV3('issue', $body, $null) }

    [object] Update([string]$issueKey, [object]$body) {
        return $this.Http.PutV3("issue/$issueKey", $body, $null)
    }

    [void] Delete([string]$issueKey, [bool]$deleteSubtasks) {
        $q = @{}
        if ($deleteSubtasks) { $q.deleteSubtasks = 'true' }
        [void]$this.Http.DeleteV3("issue/$issueKey", $q)
    }

    [object] Assign([string]$issueKey, [string]$accountId) {
        $body = @{ accountId = $accountId }
        return $this.Http.PutV3("issue/$issueKey/assignee", $body, $null)
    }

    [object] AddComment([string]$issueKey, [object]$body) {
        return $this.Http.PostV3("issue/$issueKey/comment", $body, $null)
    }

    [object] UpdateComment([string]$issueKey, [string]$commentId, [object]$body) {
        return $this.Http.PutV3("issue/$issueKey/comment/$commentId", $body, $null)
    }

    [void] DeleteComment([string]$issueKey, [string]$commentId) {
        [void]$this.Http.DeleteV3("issue/$issueKey/comment/$commentId", $null)
    }

    [object] GetTransitions([string]$issueKey) {
        return $this.Http.GetV3("issue/$issueKey/transitions", $null)
    }

    [object] Transition([string]$issueKey, [string]$transitionId, [object]$fields, [object]$update) {
        $t = @{ id = $transitionId }
        $body = @{ transition = $t }
        if ($fields) { $body.fields = $fields }
        if ($update) { $body.update = $update }
        return $this.Http.PostV3("issue/$issueKey/transitions", $body, $null)
    }

    [object] CreateRemoteIssueLink([string]$issueKey, [object]$body) {
        return $this.Http.PostV3("issue/$issueKey/remotelink", $body, $null)
    }

    [object] CreateIssueLink([object]$body) { return $this.Http.PostV3('issueLink', $body, $null) }

    [void] DeleteIssueLink([string]$linkId) { [void]$this.Http.DeleteV3("issueLink/$linkId", $null) }

    [void] DeleteIssueLinkBetween([string]$issueKey, [string]$otherKey, [string]$linkTypeName) {
        $issue = $this.Get($issueKey, @('issuelinks'), $null)
        $links = @($issue.fields.issuelinks)
        foreach ($ln in $links) {
            $in = $ln.inwardIssue.key
            $out = $ln.outwardIssue.key
            $match = ($in -eq $otherKey -or $out -eq $otherKey)
            $typeOk = -not $linkTypeName -or $ln.type.name -eq $linkTypeName
            if ($match -and $typeOk -and $ln.id) {
                $this.DeleteIssueLink("$($ln.id)")
                return
            }
        }
        throw "No matching issue link between $issueKey and $otherKey"
    }

    [object] GetIssueLinks([string]$issueKey) {
        $issue = $this.Get($issueKey, @('issuelinks'), $null)
        return $issue.fields.issuelinks
    }

    [object] AddAttachment([string]$issueKey, [string]$filePath) {
        return $this.Http.PostMultipartV3("issue/$issueKey/attachments", $filePath)
    }

    [object] GetAttachmentsMeta([string]$issueKey) {
        $issue = $this.Get($issueKey, @('attachment'), $null)
        return $issue.fields.attachment
    }

    [void] DeleteAttachment([string]$attachmentId) {
        [void]$this.Http.DeleteV3("attachment/$attachmentId", $null)
    }

    [void] Watch([string]$issueKey, [string]$accountId) {
        $body = @{ accountId = $accountId }
        [void]$this.Http.PostV3("issue/$issueKey/watchers", $body, $null)
    }

    [void] Unwatch([string]$issueKey, [string]$accountId) {
        [void]$this.Http.DeleteV3("issue/$issueKey/watchers", @{ accountId = $accountId })
    }
}
