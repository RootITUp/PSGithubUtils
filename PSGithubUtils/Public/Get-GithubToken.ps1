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
        [Parameter(Mandatory, ParameterSetName = "Data")]
        [string]
        $KeyData,
        [Parameter(Mandatory, ParameterSetName = "Path")]
        [string]
        $KeyPath,
        [Parameter(ParameterSetName = "Path")]
        [string]
        $Passphrase,
        [Parameter(Mandatory, ParameterSetName = "Data")]
        [Parameter(Mandatory, ParameterSetName = "Path")]
        [int]
        $AppId,
        [Parameter(Mandatory, ParameterSetName = "Data")]
        [Parameter(Mandatory, ParameterSetName = "Path")]
        [int]
        $InstallationId
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        "Data" {
            $jwt = Get-JWTToken -AppId $AppId -KeyData $KeyData
        }
        "Path" {
            $jwt = Get-JWTToken -AppId $AppId -KeyPath $KeyPath -Passphrase $Passphrase
        }
        default {
            throw [System.NotImplementedException]::new($PSCmdlet.ParameterSetName)
        }
    }

    $headers = @{
        Authorization          = "Bearer $jwt"
        Accept                 = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }

    $url = "https://api.github.com/app/installations/$InstallationId/access_tokens"
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method POST

    return $response.token
}