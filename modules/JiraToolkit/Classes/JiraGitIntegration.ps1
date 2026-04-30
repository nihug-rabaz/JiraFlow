class JiraGitIntegration {
    hidden [JiraIssueApi] $Issues
    hidden [JiraUserApi] $Users

    JiraGitIntegration([JiraIssueApi]$issues, [JiraUserApi]$users) {
        $this.Issues = $issues
        $this.Users = $users
    }

    static [string] RunGit([string]$repoRoot, [string]$args) {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = 'git'
        $psi.Arguments = $args
        $psi.WorkingDirectory = $repoRoot
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.UseShellExecute = $false
        $psi.CreateNoWindow = $true
        $p = [System.Diagnostics.Process]::Start($psi)
        $out = $p.StandardOutput.ReadToEnd()
        $err = $p.StandardError.ReadToEnd()
        $p.WaitForExit()
        if ($p.ExitCode -ne 0) { throw "git failed: $err" }
        return $out
    }

    static [string[]] ExtractIssueKeys([string]$text) {
        $pattern = '\b([A-Z][A-Z0-9]+-\d+)\b'
        $m = [regex]::Matches($text, $pattern)
        $set = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($x in $m) { [void]$set.Add($x.Groups[1].Value) }
        return @($set)
    }
}
