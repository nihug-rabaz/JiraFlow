class JiraRestClient {
    [JiraConnectionConfig] $Config
    hidden [hashtable] $HeadersJson
    hidden [hashtable] $HeadersMultipart

    JiraRestClient([JiraConnectionConfig]$config) {
        $this.Config = $config
        $base = $config.AuthHeaders()
        $this.HeadersJson = $base.Clone()
        $this.HeadersJson['Content-Type'] = 'application/json'
        $this.HeadersMultipart = $base.Clone()
        $this.HeadersMultipart['X-Atlassian-Token'] = 'no-check'
    }

    hidden [string] BuildQuery([hashtable]$query) {
        if (-not $query -or $query.Count -eq 0) { return '' }
        $parts = [System.Collections.ArrayList]::new()
        foreach ($k in $query.Keys) {
            $v = $query[$k]
            if ($null -eq $v) { continue }
            if ($v -is [array]) {
                foreach ($item in $v) {
                    [void]$parts.Add(("{0}={1}" -f [uri]::EscapeDataString($k), [uri]::EscapeDataString("$item")))
                }
            }
            else {
                [void]$parts.Add(("{0}={1}" -f [uri]::EscapeDataString($k), [uri]::EscapeDataString("$v")))
            }
        }
        if ($parts.Count -eq 0) { return '' }
        return '?' + ($parts -join '&')
    }

    hidden [object] InvokeRaw([string]$uri, [string]$method, $body, [hashtable]$headers, [string]$contentType) {
        $params = @{
            Uri             = $uri
            Method          = $method
            Headers         = $headers
            ErrorAction     = 'Stop'
        }
        if ($null -ne $body) {
            $jsonText = if ($body -is [string]) { $body } else { ($body | ConvertTo-Json -Depth 30 -Compress) }
            $params.Body = [System.Text.Encoding]::UTF8.GetBytes($jsonText)
        }
        if ($contentType) { $params.ContentType = "$contentType; charset=utf-8" }
        try {
            return Invoke-RestMethod @params
        }
        catch {
            $err = $_.ErrorDetails.Message
            if ($err) {
                throw ("Jira API error: {0} | {1}" -f $_.Exception.Message, $err)
            }
            throw
        }
    }

    [object] GetV3([string]$path, [hashtable]$query) {
        $uri = $this.Config.ApiV3Root() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Get', $null, $this.Config.AuthHeaders(), $null)
    }

    [object] PostV3([string]$path, $body, [hashtable]$query) {
        $uri = $this.Config.ApiV3Root() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Post', $body, $this.HeadersJson, 'application/json')
    }

    [object] PutV3([string]$path, $body, [hashtable]$query) {
        $uri = $this.Config.ApiV3Root() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Put', $body, $this.HeadersJson, 'application/json')
    }

    [object] DeleteV3([string]$path, [hashtable]$query) {
        $uri = $this.Config.ApiV3Root() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Delete', $null, $this.Config.AuthHeaders(), $null)
    }

    [object] GetAgile([string]$path, [hashtable]$query) {
        $uri = $this.Config.AgileRoot() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Get', $null, $this.Config.AuthHeaders(), $null)
    }

    [object] PostAgile([string]$path, $body, [hashtable]$query) {
        $uri = $this.Config.AgileRoot() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Post', $body, $this.HeadersJson, 'application/json')
    }

    [object] PutAgile([string]$path, $body, [hashtable]$query) {
        $uri = $this.Config.AgileRoot() + '/' + $path.TrimStart('/') + $this.BuildQuery($query)
        return $this.InvokeRaw($uri, 'Put', $body, $this.HeadersJson, 'application/json')
    }

    [object] PostMultipartV3([string]$path, [string]$filePath) {
        $uri = $this.Config.ApiV3Root() + '/' + $path.TrimStart('/')
        Add-Type -AssemblyName System.Net.Http
        $handler = [System.Net.Http.HttpClientHandler]::new()
        $client = [System.Net.Http.HttpClient]::new($handler)
        try {
            $req = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post, $uri)
            foreach ($k in $this.HeadersMultipart.Keys) {
                $req.Headers.TryAddWithoutValidation($k, $this.HeadersMultipart[$k]) | Out-Null
            }
            $content = [System.Net.Http.MultipartFormDataContent]::new()
            $fs = [System.IO.File]::OpenRead($filePath)
            try {
                $sc = [System.Net.Http.StreamContent]::new($fs)
                $fn = [System.IO.Path]::GetFileName($filePath)
                $content.Add($sc, 'file', $fn)
                $req.Content = $content
                $resp = $client.SendAsync($req).GetAwaiter().GetResult()
                $txt = $resp.Content.ReadAsStringAsync().GetAwaiter().GetResult()
                if (-not $resp.IsSuccessStatusCode) {
                    throw "Attachment upload failed: $($resp.StatusCode) $txt"
                }
                return ($txt | ConvertFrom-Json)
            }
            finally { $fs.Dispose() }
        }
        finally { $client.Dispose(); $handler.Dispose() }
    }

    [object] SearchJql([string]$jql, [string[]]$fields, [int]$maxPerPage, [int]$maxTotal) {
        $all = [System.Collections.ArrayList]::new()
        $page = [Math]::Max(1, [Math]::Min(100, $maxPerPage))
        $cap = if ($maxTotal -gt 0) { $maxTotal } else { [int]::MaxValue }
        $nextToken = $null
        while ($true) {
            $body = @{ jql = $jql; maxResults = $page }
            if ($fields -and $fields.Count -gt 0) { $body.fields = $fields }
            if ($nextToken) { $body.nextPageToken = $nextToken }
            $r = $this.PostV3('search/jql', $body, $null)
            $batch = @($r.issues)
            foreach ($it in $batch) { [void]$all.Add($it) }
            if ($all.Count -ge $cap) { break }
            if ($r.isLast -eq $true -or $batch.Count -eq 0) { break }
            if (-not $r.nextPageToken) { break }
            $nextToken = $r.nextPageToken
        }
        if ($all.Count -gt $cap) {
            return $all[0..($cap - 1)]
        }
        return @($all)
    }
}
