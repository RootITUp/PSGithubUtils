<#
.SYNOPSIS
Creates a new organization membership for a user.

.DESCRIPTION
Implements the API call documented within https://docs.github.com/en/rest/orgs/members?apiVersion=2022-11-28#create-an-organization-invitation.

.PARAMETER Token
The Token retrieved using the Get-GithubToken. The Application used during retrieval has to have permissions to the organization.

.PARAMETER Organization
The name of the organization.

.PARAMETER Email
The mail address (UPN) of the user.

.EXAMPLE
New-OrganizationMember -Token $token -Organization "adesso-Copilot" -Email "torben.soennecken@adesso.de"
#>
function New-OrganizationMember {
    param(
        [Parameter(Mandatory)]
        [string]
        $Token,
        [Parameter(Mandatory)]
        [string]
        $Organization,
        [Parameter(Mandatory)]
        [string]
        $Email
    )

    $headers = @{
        Authorization          = "Bearer $Token"
        Accept                 = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }

    $body = @{
        email = $Email
        role  = "direct_member"
    }
    $jsonBody = ConvertTo-Json -InputObject $body
    $rawBody = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)

    $url = "https://api.github.com/orgs/$Organization/invitations"
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Body $rawBody -Method POST

    return $response
}