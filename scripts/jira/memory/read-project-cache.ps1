#requires -Version 5.1
[CmdletBinding()]
param()
. (Join-Path (Join-Path $PSScriptRoot '..') '_Bootstrap.ps1')
. (Join-Path $PSScriptRoot 'JiraMemoryStore.ps1')
$store = [JiraMemoryStore]::new($PSScriptRoot)
$store.ReadProjects() | ConvertTo-Json -Depth 10
