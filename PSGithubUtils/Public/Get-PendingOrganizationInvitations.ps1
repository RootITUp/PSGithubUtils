<#
.SYNOPSIS
Lists all pending organization invitations.

.DESCRIPTION
Implements the API call documented within https://docs.github.com/en/free-pro-team@latest/rest/orgs/members?apiVersion=2022-11-28#list-pending-organization-invitations.

.PARAMETER Token
The Token retrieved using the Get-GithubToken. The Application used during retrieval has to have permissions to the organization.

.PARAMETER Organization
The name of the organization.

.EXAMPLE
Get-PendingOrganizationInvitations -Token $token -Organization "adesso-Copilot"
#>
function Get-PendingOrganizationInvitations {
    param(
        [Parameter(Mandatory)]
        [string]
        $Token,
        [Parameter(Mandatory)]
        [string]
        $Organization
    )

    $headers = @{
        Authorization          = "Bearer $Token"
        Accept                 = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }

    $url = "https://api.github.com/orgs/$Organization/invitations"
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method GET

    return $response
}