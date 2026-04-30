#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ParentKey,
    [Parameter(Mandatory)][string]$Summary,
    [string]$Description,
    [string]$BodyJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
if ($BodyJson) {
    $body = $BodyJson | ConvertFrom-Json
}
else {
    $body = @{
        fields = @{
            parent    = @{ key = $ParentKey }
            summary   = $Summary
            issuetype = @{ name = 'Sub-task' }
        }
    }
    if ($Description) { $body.fields.description = @{ type = 'doc'; version = 1; content = @(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $Description }) }) } }
}
$s.Issues.Create($body) | Write-Output
