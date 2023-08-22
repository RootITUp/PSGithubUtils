#-- Strict
Set-StrictMode -Version 2.0
$Global:ErrorActionPreference = "Stop"
#--

# Dot source the files
$Private:files = @()
$Private:files += Get-ChildItem -Path "$PSScriptRoot" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

foreach ($file in $Private:files) {
    Try {
        . $file.fullname
    }
    Catch {
        Throw "Failed to import function $($file.fullname): $_"
    }
}

$securityLibPath = ""
if ($PSVersionTable.PSVersion.Major -lt 7){
    $securityDll = Get-ChildItem -Path "$PSScriptRoot\lib\BouncyCastle.Cryptography.2.2.1\lib\net461\BouncyCastle.Cryptography.dll"
    $securityLibPath = $securityDll.FullName
}else{
    throw [System.NotImplementedException]::new($PSVersionTable.PSVersion)
}

Add-Type -Path $securityLibPath
Add-Type -TypeDefinition (Get-Content -Path "$PSScriptRoot\lib\Private\BasicPasswordFinder.cs" -Raw) -ReferencedAssemblies @($securityLibPath)