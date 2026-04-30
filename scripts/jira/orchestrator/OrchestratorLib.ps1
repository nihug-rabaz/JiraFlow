class JiraOrchestrationEngine {
    static [object] ReadRequest([string]$jsonText) {
        return $jsonText | ConvertFrom-Json
    }

    static [object] ResolveIntent([object]$mapper, [string]$intent, [hashtable]$aliases) {
        $key = $intent
        if ($aliases -and $aliases.ContainsKey($intent)) {
            $key = [string]$aliases[$intent]
        }
        $bucket = $mapper.intents
        $names = @($bucket.PSObject.Properties | ForEach-Object { $_.Name })
        if ($names -notcontains $key) {
            throw "Unknown intent '$intent' (resolved '$key')."
        }
        return $bucket.$key
    }

    static [hashtable] DataToSplat([object]$data) {
        $h = @{}
        if (-not $data) { return $h }
        foreach ($p in $data.PSObject.Properties) {
            $h[$p.Name] = $p.Value
        }
        return $h
    }

    static [void] Run([object]$mapper, [object]$request, [string]$repoRoot, [hashtable]$aliases, [switch]$DryRun, [switch]$Force) {
        $def = [JiraOrchestrationEngine]::ResolveIntent($mapper, [string]$request.intent, $aliases)
        if ($def.requireConfirm -eq $true -and -not $Force) {
            $tok = $null
            if ($request.PSObject.Properties.Name -contains 'confirmToken') { $tok = $request.confirmToken }
            if ($tok -ne 'CONFIRM_DESTRUCTIVE') {
                throw "Destructive intent requires -Force or request.confirmToken = 'CONFIRM_DESTRUCTIVE'."
            }
        }
        $rel = [string]$def.script -replace '/', [IO.Path]::DirectorySeparatorChar
        $scriptPath = Join-Path $repoRoot $rel
        if (-not (Test-Path -LiteralPath $scriptPath)) {
            throw "Script not found: $scriptPath"
        }
        $splat = [JiraOrchestrationEngine]::DataToSplat($request.data)
        if ($DryRun) {
            Write-Host "[DryRun] $scriptPath"
            $splat.GetEnumerator() | ForEach-Object { Write-Host ("  {0} = {1}" -f $_.Key, $_.Value) }
            return
        }
        & $scriptPath @splat
    }
}
