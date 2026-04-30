#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Message,
    [switch]$Interactive,
    [switch]$Force
)
if ($Force) { return $true }
if ($env:JIRA_CONFIRM_DESTRUCTIVE -eq '1') { return $true }
if (-not $Interactive) {
    throw "confirm-destructive-action: non-interactive mode requires -Force or JIRA_CONFIRM_DESTRUCTIVE=1. $Message"
}
$ans = Read-Host "$Message Type YES to proceed"
return ($ans -eq 'YES')
