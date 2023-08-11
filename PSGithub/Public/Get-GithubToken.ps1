<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER KeyPath
Parameter description

.PARAMETER AppId
Parameter description

.PARAMETER InstallationId
Parameter description

.EXAMPLE
Get-GithubToken -KeyPath C:\secret.pem -AppId 369225 -InstallationId 40233370

.NOTES
General notes
#>
function Get-GithubToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $KeyPath,
        [Parameter(Mandatory)]
        [int]
        $AppId,
        [Parameter(Mandatory)]
        [int]
        $InstallationId
    )
    
    $jwt = Get-JWTToken -AppId $AppId -KeyPath $KeyPath

    $headers = @{
        Authorization          = "Bearer $jwt"
        Accept                 = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }

    $url = "https://api.github.com/app/installations/$InstallationId/access_tokens"
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method POST

    return $response.token
}