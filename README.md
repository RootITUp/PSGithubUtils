# PSGithub

The PSGithub module provides some basic interactions with the Github API. Importantly, it supports authentication using Github Applications with private keys in unencrypted PKCS#8 format.

## Basic Usage

After obtaining the secret, the first step is to obtain a github session token to be used for the future calls.

```powershell
$token = Get-GithubToken -KeyPath C:\secret.pem -AppId 369225 -InstallationId 40233370
New-OrganizationMember -Token $token -Organization "adesso-Copilot" -Email "torben.soennecken@adesso.de"
```

## Using PowerShellForGithub

```powershell
Set-GitHubConfiguration -DisableTelemetry
Get-GitHubOrganizationMember -AccessToken $token -OrganizationName "adesso-Copilot"
Test-GitHubOrganizationMember -AccessToken $token -OrganizationName "adesso-Copilot" -UserName "MarkusSchoelzel"
```