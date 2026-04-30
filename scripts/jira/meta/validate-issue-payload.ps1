#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ProjectKey,
    [Parameter(Mandatory)][string]$IssueTypeName,
    [Parameter(Mandatory)][string]$FieldsJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$meta = $s.Meta.GetCreateMeta(@{ projectKeys = $ProjectKey; expand = 'projects.issuetypes.fields' })
$fields = $FieldsJson | ConvertFrom-Json
Invoke-JiraValidateCreatePayload $meta $ProjectKey $IssueTypeName $fields.fields
Write-Host 'Payload passes required-field check for createmeta.'
