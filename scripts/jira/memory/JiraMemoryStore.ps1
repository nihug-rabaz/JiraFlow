class JiraMemoryStore {
    hidden [string] $Root

    JiraMemoryStore([string]$memoryDirectory) {
        $this.Root = $memoryDirectory
    }

    [object] ReadProjects() {
        $p = Join-Path $this.Root 'cache-projects.json'
        return (Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json)
    }

    [object] ReadIssues() {
        $p = Join-Path $this.Root 'cache-issues.json'
        return (Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json)
    }

    [void] WriteProjects([object]$payload) {
        $p = Join-Path $this.Root 'cache-projects.json'
        $payload | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $p -Encoding UTF8
    }

    [void] WriteIssues([object]$payload) {
        $p = Join-Path $this.Root 'cache-issues.json'
        $payload | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $p -Encoding UTF8
    }
}
