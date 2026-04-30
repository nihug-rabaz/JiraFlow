#requires -Version 5.1
[CmdletBinding(DefaultParameterSetName = 'Id')]
param(
    [Parameter(Mandatory)][string]$IssueKey,
    [Parameter(ParameterSetName = 'Id')][string]$TransitionId,
    [Parameter(ParameterSetName = 'Name')][string]$TransitionName,
    [string]$FieldsJson,
    [string]$UpdateJson
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$tid = $TransitionId
if ($PSCmdlet.ParameterSetName -eq 'Name') {
    $tr = $s.Issues.GetTransitions($IssueKey)
    $match = @($tr.transitions) | Where-Object { $_.name -eq $TransitionName } | Select-Object -First 1
    if (-not $match) { throw "Transition not found: $TransitionName" }
    $tid = "$($match.id)"
}
$fields = $null
$update = $null
if ($FieldsJson) { $fields = $FieldsJson | ConvertFrom-Json }
if ($UpdateJson) { $update = $UpdateJson | ConvertFrom-Json }
$s.Issues.Transition($IssueKey, $tid, $fields, $update) | Write-Output
