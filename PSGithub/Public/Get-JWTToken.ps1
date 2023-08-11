function Get-JWTToken {
    param(
        [Parameter(Mandatory)]
        [string]
        $KeyPath,
        [Parameter(Mandatory)]
        [int]
        $AppId,
        [ValidateScript({ $_ -gt 30 })]
        [int]
        $ExpirationInSeconds = 600 # 10 Minutes
    )

    # A) Construct Header
    $header = ConvertTo-Json -InputObject @{
        alg = 'RS256'
        typ = 'JWT'
    }

    # B) Construct Payload
    $now = [DateTimeOffset]::Now.ToUnixTimeSeconds()
    $payload = ConvertTo-Json -InputObject @{
        iat = $now
        exp = $now + $ExpirationInSeconds
        iss = $appId
    }

    # C) Create JWT Token
    $jwtHeader = Get-Base64UrlEncoded -InputObject $header
    $jwtPayload = Get-Base64UrlEncoded -InputObject $payload
    $jwtTokenUnsigned = "$jwtHeader.$jwtPayload"
    
    # D) Create Signature

    ## 1.) Load PEM
    $keyData = Get-Content -Path $KeyPath -Raw
    $reader = [System.IO.StringReader]::new($keyData)
    try{
        $pemReader = New-Object Org.BouncyCastle.OpenSsl.PemReader $reader
        $keyPair = $pemReader.ReadObject()
    }finally{
        $reader.Close()
    }

    ## 2.) Prepare Signer
    $signer = [Org.BouncyCastle.Security.SignerUtilities]::GetSigner("SHA256withRSA")
    $signer.Init($true, $keyPair.Private)

    ## 3.) Create Signature
    $jwtTokenUnsignedRaw = [Text.Encoding]::UTF8.GetBytes($jwtTokenUnsigned)
    $signer.BlockUpdate($jwtTokenUnsignedRaw, 0, $jwtTokenUnsignedRaw.Length)
    $signatureRaw = $signer.GenerateSignature()
    $jwtSignature = Get-Base64UrlEncoded -InputObject ($signatureRaw)

    return "$jwtTokenUnsigned.$jwtSignature"
}