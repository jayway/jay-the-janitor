function Get-SlackToken {
    [xml]$tokenFile = Get-Content .\slack-token.xml
    return $tokenFile.tokens.testToken
}

function Get-SlackFiles {
    $token = Get-SlackToken
    $listFilesUrl = "https://slack.com/api/files.list?token=$token" # token from https://api.slack.com/custom-integrations/legacy-tokens
    $listFilesResult = Invoke-RestMethod "$listFilesUrl&count=1"
    $totalFileCount = $listFilesResult.paging.total
    Invoke-RestMethod "$listFilesUrl&count=$totalFileCount" `
    | Select-Object -ExpandProperty files
}
