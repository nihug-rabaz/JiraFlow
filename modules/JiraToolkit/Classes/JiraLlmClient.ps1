class JiraLlmClient {
    hidden [string] $ApiKey
    hidden [string] $Model

    JiraLlmClient() {
        $this.ApiKey = $env:OPENAI_API_KEY
        $this.Model = if ($env:OPENAI_MODEL) { $env:OPENAI_MODEL } else { 'gpt-4o-mini' }
    }

    [string] Complete([string]$systemPrompt, [string]$userPrompt) {
        if (-not $this.ApiKey) { throw "OPENAI_API_KEY is not set" }
        $uri = 'https://api.openai.com/v1/chat/completions'
        $body = @{
            model    = $this.Model
            messages = @(
                @{ role = 'system'; content = $systemPrompt }
                @{ role = 'user'; content = $userPrompt }
            )
        }
        $hdr = @{ Authorization = "Bearer $($this.ApiKey)" }
        $r = Invoke-RestMethod -Uri $uri -Method Post -Headers $hdr -Body ($body | ConvertTo-Json -Depth 10 -Compress) -ContentType 'application/json'
        return $r.choices[0].message.content
    }
}
