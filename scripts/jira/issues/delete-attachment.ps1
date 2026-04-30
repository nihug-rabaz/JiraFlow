#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$AttachmentId
)
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
$s = New-JiraToolkitSession
$s.Issues.DeleteAttachment($AttachmentId)
Write-Host "Deleted attachment $AttachmentId"
