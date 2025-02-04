<#
Contains common functions for HashiVault Credential Operations
#>

function SEC-ReadVaultSecret {
    [CmdletBinding()]
    param(
        [ValidateExpression('^https?:\/\/[a-z0-9\.]+(:[0-9]+)?$')]
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Endpoint,
        [ValidatePattern('^\/[a-zA-Z0-9\/-]+$')]
        [Parameter(Position=1, Mandatory=$True)]
        [string]$Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=2, Mandatory=$True)]
        [string]$Token
    )

    $headers = @{
        "X-Vault-Token" = $Token
    }
    try {
        Invoke-WebRequest -uri "$Endpoint$Path" -Method GET -Headers $Headers -UseBasicParsing
    } catch {
        $_; exit 1
    }
}

function SEC-WriteVaultSecret {
    [CmdletBinding()]
    param(
        [ValidateExpression('^https?:\/\/[a-z0-9\.]+(:[0-9]+)?$')]
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Endpoint,
        [ValidatePattern('^\/[a-zA-Z0-9\/-]+$')]
        [Parameter(Position=1, Mandatory=$True)]
        [string]$Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=2, Mandatory=$True)]
        [string]$Token,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=3, Mandatory=$True)]
        [hashtable]$Secret    
    )
    foreach ($key in $Secret.Keys) {
        if (-not($Secret[$key] -is [string])) {exit 1}
        if ($Secret[$key].Length -eq 0) {exit 1}
    }
    $Headers = @{
        "X-Vault-Token" = $Token
    }
    $Data = @{
        "data" = $Secret
    }

    try {
        Invoke-RestMethod -uri "$Endpoint$Path" -Method POST -Headers $Headers -Body ($Data | ConvertTo-Json)
    } catch {
        $_; exit 1
    }
}

Export-ModuleMember -Function SEC-WriteVaultSecret
Export-ModuleMember -Function SEC-ReadVaultSecret
