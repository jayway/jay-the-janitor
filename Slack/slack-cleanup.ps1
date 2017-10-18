Import-Module ./slack.psm1 -Force
$slackFilesCache = './slack-files.json'
if (!(Test-Path $slackFilesCache)) {
    Get-SlackFiles | ConvertTo-Json | Out-File $slackFilesCache
}

$files = Get-Content $slackFilesCache | ConvertFrom-Json

$totalFileSize = $files `
| Sort-Object -Descending size `
| Measure-Object -Property size -Sum `
| Select-Object -ExpandProperty Sum

$megabytes = $totalFileSize / [math]::Pow(1024, 2) # megabytes

"There are public files totalling $megabytes MB"
