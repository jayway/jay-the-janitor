function Get-GitHubAuthToken {
    Get-Content ./github-token.txt
}

function Get-GitHubNextLink {
    param(
        $response
    )
    return [regex]::match($response.Headers.Link, '<(https://.*)>; rel="next"').Groups[1].Value
}

function Get-GitHubAllPages {
    param(
        [string] $uri
    )

    $next = "https://api.github.com$uri`?per_page=100"
    [Object[]] $items
    while ($next) {
        $response = Invoke-WebRequest -Method Get -Uri $next -Headers @{ Authorization = "token $(Get-GitHubAuthToken)"}
        $new_items = $response.Content | ConvertFrom-Json
        $items = $items + $new_items
        $next = Get-GitHubNextLink $response
    }
    return $items
}

function Get-GitHubOrganizationMembers {
    Get-GitHubAllPages "/orgs/jayway/members"
}

function Get-GitHubRepositories {
    Get-GitHubAllPages "/orgs/jayway/repos"
}
