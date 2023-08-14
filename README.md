# PSGithubUtils

The PSGithubUtils module provides some basic interactions with the Github API. Importantly, it supports authentication using Github Applications with private keys in unencrypted PKCS#8 format.

## Basic Usage

After obtaining the secret, the first step is to obtain a github session token to be used for the future calls.

```powershell
$token = Get-GithubToken -KeyPath C:\secret.pem -AppId 2131234 -InstallationId 5342523356
New-OrganizationMember -Token $token -Organization "Organization123" -Email "asdasd@test.de"
```

```powershell
# Given a private key encrypted via "openssl rsa -in secret.pem -aes256 -out encrypted-secret.pem"
$token = Get-GithubToken -KeyPath C:\encrypted-secret.pem -Passphrase $passphrase -AppId 2131234 -InstallationId 5342523356
```

## Using PowerShellForGithub

```powershell
Set-GitHubConfiguration -DisableTelemetry
Get-GitHubOrganizationMember -AccessToken $token -OrganizationName "Organization123"
Test-GitHubOrganizationMember -AccessToken $token -OrganizationName "Organization123" -UserName "User123"
```

## Authors

- **Torben Soennecken**
