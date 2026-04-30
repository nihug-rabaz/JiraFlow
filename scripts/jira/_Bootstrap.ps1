$script:JiraToolkitRepoRoot = $null
for ($d = $PSScriptRoot; $d; $d = Split-Path -Parent $d) {
    $candidate = Join-Path $d 'modules\JiraToolkit\JiraToolkit.psd1'
    if (Test-Path -LiteralPath $candidate) {
        $script:JiraToolkitRepoRoot = (Resolve-Path -LiteralPath $d).Path
        break
    }
    $parent = Split-Path -Parent $d
    if ($parent -eq $d) { break }
}
if (-not $script:JiraToolkitRepoRoot) {
    throw 'JiraToolkit repo root not found. Expected modules/JiraToolkit/JiraToolkit.psd1 in a parent of this script.'
}
Import-Module (Join-Path $script:JiraToolkitRepoRoot 'modules\JiraToolkit\JiraToolkit.psd1') -Force
$JiraToolkitRepoRoot = $script:JiraToolkitRepoRoot
