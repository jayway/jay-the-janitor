Import-Module ./github.psm1 -Force

if (!(Test-Path ./github-repos.json)) {
    Get-GitHubRepositories `
    | ConvertTo-Json `
    | Out-File ./github-repos.json
}

$repos = Get-Content ./github-repos.json | ConvertFrom-Json

$years = 3

$oldRepos = $repos `
| Where-Object private -EQ $true `
| Where-Object { [System.DateTime]::Parse($_.updated_at) -LT ([System.DateTime]::UtcNow).AddYears(-$years) } `
| Where-Object { [System.DateTime]::Parse($_.pushed_at) -LT ([System.DateTime]::UtcNow).AddYears(-$years) }

$oldRepos
