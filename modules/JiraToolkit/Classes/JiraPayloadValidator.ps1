class JiraPayloadValidator {
    hidden static [bool] FieldPresent([object]$fields, [string]$key) {
        if ($fields -is [hashtable]) { return $fields.ContainsKey($key) }
        if ($null -eq $fields) { return $false }
        foreach ($p in $fields.PSObject.Properties) { if ($p.Name -eq $key) { return $true } }
        return $false
    }

    static [void] ValidateCreatePayload([object]$createMeta, [string]$projectKey, [string]$issueTypeName, [object]$fields) {
        $projects = @($createMeta.projects)
        $p = $projects | Where-Object { $_.key -eq $projectKey } | Select-Object -First 1
        if (-not $p) { throw "Project $projectKey not found in createmeta" }
        $types = @($p.issuetypes)
        $t = $types | Where-Object { $_.name -eq $issueTypeName } | Select-Object -First 1
        if (-not $t) { throw "Issue type $issueTypeName not valid for project" }
        if (-not $t.fields) { return }
        $req = @($t.fields.PSObject.Properties | Where-Object {
                $_.Value.required -eq $true -and $_.Name -ne 'project' -and $_.Name -ne 'issuetype'
            })
        foreach ($r in $req) {
            $fn = $r.Name
            if (-not [JiraPayloadValidator]::FieldPresent($fields, $fn)) {
                throw "Missing required field: $fn"
            }
        }
    }
}
