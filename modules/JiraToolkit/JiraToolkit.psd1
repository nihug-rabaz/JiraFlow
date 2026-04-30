@{
    RootModule        = 'JiraToolkit.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author            = 'JiraToolkit'
    Description       = 'Jira Cloud REST API helpers (OOP) for PowerShell 5.1+'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('New-JiraToolkitSession', 'Invoke-JiraGitCommand', 'Get-JiraKeysFromText', 'Invoke-JiraValidateCreatePayload')
}
