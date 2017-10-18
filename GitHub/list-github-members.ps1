Import-Module ./github.psm1 -Force

if (!(Test-Path .\github-members.json)) {
    Get-GitHubOrganizationMembers `
    | ConvertTo-Json `
    | Out-File .\github-members.json
}

Get-Content .\github-members.json `
| ConvertFrom-Json `
| Select-Object -ExpandProperty SyncRoot
