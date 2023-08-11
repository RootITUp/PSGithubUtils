function Get-Base64UrlEncoded {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $InputObject
    )

    if ($InputObject -is [string]) {
        return [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($InputObject)) -replace '\+', '-' -replace '/', '_' -replace '='
    }
    elseif ($InputObject -is [byte[]]) {
        return [Convert]::ToBase64String($InputObject) -replace '\+', '-' -replace '/', '_' -replace '='
    }
    else {
        throw "Get-Base64UrlEncoded requires string or byte array input, received $($InputObject.GetType())"
    }
}